
/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/libraries/resolver/Lib_ResolvedDelegateProxy.sol
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
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/libraries/resolver/Lib_ResolvedDelegateProxy.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

/* Library ////Imports */
import { Lib_AddressManager } from "./Lib_AddressManager.sol";

/**
 * @title Lib_ResolvedDelegateProxy
 */
contract Lib_ResolvedDelegateProxy {
    /*************
     * Variables *
     *************/

    // Using mappings to store fields to avoid overwriting storage slots in the
    // implementation contract. For example, instead of storing these fields at
    // storage slot `0` & `1`, they are stored at `keccak256(key + slot)`.
    // See: https://solidity.readthedocs.io/en/v0.7.0/internals/layout_in_storage.html
    // NOTE: Do not use this code in your own contract system.
    //      There is a known flaw in this contract, and we will remove it from the repository
    //      in the near future. Due to the very limited way that we are using it, this flaw is
    //      not an issue in our system.
    mapping(address => string) private implementationName;
    mapping(address => Lib_AddressManager) private addressManager;

    /***************
     * Constructor *
     ***************/

    /**
     * @param _libAddressManager Address of the Lib_AddressManager.
     * @param _implementationName implementationName of the contract to proxy to.
     */
    constructor(address _libAddressManager, string memory _implementationName) {
        addressManager[address(this)] = Lib_AddressManager(_libAddressManager);
        implementationName[address(this)] = _implementationName;
    }

    /*********************
     * Fallback Function *
     *********************/

    fallback() external payable {
        address target = addressManager[address(this)].getAddress(
            (implementationName[address(this)])
        );

        require(target != address(0), "Target address must be initialized.");

        // slither-disable-next-line controlled-delegatecall
        (bool success, bytes memory returndata) = target.delegatecall(msg.data);

        if (success == true) {
            assembly {
                return(add(returndata, 0x20), mload(returndata))
            }
        } else {
            assembly {
                revert(add(returndata, 0x20), mload(returndata))
            }
        }
    }
}

