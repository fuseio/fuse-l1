
/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L1/deployment/AddressDictator.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

/* External ////Imports */
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Lib_AddressManager
 */
contract Lib_AddressManager is Ownable {
    /**********
     * Events *
     **********/

    event AddressSet(string indexed _name, address _newAddress, address _oldAddress);

    /*************
     * Variables *
     *************/

    mapping(bytes32 => address) private addresses;

    /********************
     * Public Functions *
     ********************/

    /**
     * Changes the address associated with a particular name.
     * @param _name String name to associate an address with.
     * @param _address Address to associate with the name.
     */
    function setAddress(string memory _name, address _address) external onlyOwner {
        bytes32 nameHash = _getNameHash(_name);
        address oldAddress = addresses[nameHash];
        addresses[nameHash] = _address;

        emit AddressSet(_name, _address, oldAddress);
    }

    /**
     * Retrieves the address associated with a given name.
     * @param _name Name to retrieve an address for.
     * @return Address associated with the given name.
     */
    function getAddress(string memory _name) external view returns (address) {
        return addresses[_getNameHash(_name)];
    }

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Computes the hash of a name.
     * @param _name Name to compute a hash for.
     * @return Hash of the given name.
     */
    function _getNameHash(string memory _name) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_name));
    }
}


/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L1/deployment/AddressDictator.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

////import { Lib_AddressManager } from "../../libraries/resolver/Lib_AddressManager.sol";

/**
 * @title AddressDictator
 * @dev The AddressDictator (glory to Arstotzka) is a contract that allows us to safely manipulate
 *      many different addresses in the AddressManager without transferring ownership of the
 *      AddressManager to a hot wallet or hardware wallet.
 */
contract AddressDictator {
    /*********
     * Types *
     *********/

    struct NamedAddress {
        string name;
        address addr;
    }

    /*************
     * Variables *
     *************/

    Lib_AddressManager public manager;
    address public finalOwner;
    NamedAddress[] namedAddresses;

    /***************
     * Constructor *
     ***************/

    /**
     * @param _manager Address of the AddressManager contract.
     * @param _finalOwner Address to transfer AddressManager ownership to afterwards.
     * @param _names Array of names to associate an address with.
     * @param _addresses Array of addresses to associate with the name.
     */
    constructor(
        Lib_AddressManager _manager,
        address _finalOwner,
        string[] memory _names,
        address[] memory _addresses
    ) {
        manager = _manager;
        finalOwner = _finalOwner;
        require(
            _names.length == _addresses.length,
            "AddressDictator: Must provide an equal number of names and addresses."
        );
        for (uint256 i = 0; i < _names.length; i++) {
            namedAddresses.push(NamedAddress({ name: _names[i], addr: _addresses[i] }));
        }
    }

    /********************
     * Public Functions *
     ********************/

    /**
     * Called to finalize the transfer, this function is callable by anyone, but will only result in
     * an upgrade if this contract is the owner Address Manager.
     */
    // slither-disable-next-line calls-loop
    function setAddresses() external {
        for (uint256 i = 0; i < namedAddresses.length; i++) {
            manager.setAddress(namedAddresses[i].name, namedAddresses[i].addr);
        }
        // note that this will revert if _finalOwner == currentOwner
        manager.transferOwnership(finalOwner);
    }

    /**
     * Transfers ownership of this contract to the finalOwner.
     * Only callable by the Final Owner, which is intended to be our multisig.
     * This function shouldn't be necessary, but it gives a sense of reassurance that we can recover
     * if something really surprising goes wrong.
     */
    function returnOwnership() external {
        require(msg.sender == finalOwner, "AddressDictator: only callable by finalOwner");
        manager.transferOwnership(finalOwner);
    }

    /******************
     * View Functions *
     ******************/

    /**
     * Returns the full namedAddresses array.
     */
    function getNamedAddresses() external view returns (NamedAddress[] memory) {
        return namedAddresses;
    }
}

