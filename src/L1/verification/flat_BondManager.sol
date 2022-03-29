
/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L1/verification/BondManager.sol
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
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L1/verification/BondManager.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

/* Library ////Imports */
import { Lib_AddressManager } from "./Lib_AddressManager.sol";

/**
 * @title Lib_AddressResolver
 */
abstract contract Lib_AddressResolver {
    /*************
     * Variables *
     *************/

    Lib_AddressManager public libAddressManager;

    /***************
     * Constructor *
     ***************/

    /**
     * @param _libAddressManager Address of the Lib_AddressManager.
     */
    constructor(address _libAddressManager) {
        libAddressManager = Lib_AddressManager(_libAddressManager);
    }

    /********************
     * Public Functions *
     ********************/

    /**
     * Resolves the address associated with a given name.
     * @param _name Name to resolve an address for.
     * @return Address associated with the given name.
     */
    function resolve(string memory _name) public view returns (address) {
        return libAddressManager.getAddress(_name);
    }
}




/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L1/verification/BondManager.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

/**
 * @title IBondManager
 */
interface IBondManager {
    /********************
     * Public Functions *
     ********************/

    function isCollateralized(address _who) external view returns (bool);
}


/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L1/verification/BondManager.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

/* Interface ////Imports */
import { IBondManager } from "./IBondManager.sol";

/* Contract ////Imports */
import { Lib_AddressResolver } from "../../libraries/resolver/Lib_AddressResolver.sol";

/**
 * @title BondManager
 * @dev This contract is, for now, a stub of the "real" BondManager that does nothing but
 * allow the "OVM_Proposer" to submit state root batches.
 *
 */
contract BondManager is IBondManager, Lib_AddressResolver {
    /**
     * @param _libAddressManager Address of the Address Manager.
     */
    constructor(address _libAddressManager) Lib_AddressResolver(_libAddressManager) {}

    /**
     * Checks whether a given address is properly collateralized and can perform actions within
     * the system.
     * @param _who Address to check.
     * @return true if the address is properly collateralized, false otherwise.
     */
    // slither-disable-next-line external-function
    function isCollateralized(address _who) public view returns (bool) {
        // Only authenticate sequencer to submit state root batches.
        return _who == resolve("OVM_Proposer");
    }
}

