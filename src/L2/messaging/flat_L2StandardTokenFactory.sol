
/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L2/messaging/L2StandardTokenFactory.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

////import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
////import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IL2StandardERC20 is IERC20, IERC165 {
    function l1Token() external returns (address);

    function mint(address _to, uint256 _amount) external;

    function burn(address _from, uint256 _amount) external;

    event Mint(address indexed _account, uint256 _amount);
    event Burn(address indexed _account, uint256 _amount);
}




/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L2/messaging/L2StandardTokenFactory.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

/**
 * @title Lib_PredeployAddresses
 */
library Lib_PredeployAddresses {
    address internal constant L2_TO_L1_MESSAGE_PASSER = 0x4200000000000000000000000000000000000000;
    address internal constant L1_MESSAGE_SENDER = 0x4200000000000000000000000000000000000001;
    address internal constant DEPLOYER_WHITELIST = 0x4200000000000000000000000000000000000002;
    address payable internal constant OVM_ETH = payable(0xDeadDeAddeAddEAddeadDEaDDEAdDeaDDeAD0000);
    address internal constant L2_CROSS_DOMAIN_MESSENGER =
        0x4200000000000000000000000000000000000007;
    address internal constant LIB_ADDRESS_MANAGER = 0x4200000000000000000000000000000000000008;
    address internal constant PROXY_EOA = 0x4200000000000000000000000000000000000009;
    address internal constant L2_STANDARD_BRIDGE = 0x4200000000000000000000000000000000000010;
    address internal constant SEQUENCER_FEE_WALLET = 0x4200000000000000000000000000000000000011;
    address internal constant L2_STANDARD_TOKEN_FACTORY =
        0x4200000000000000000000000000000000000012;
    address internal constant L1_BLOCK_NUMBER = 0x4200000000000000000000000000000000000013;
}




/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L2/messaging/L2StandardTokenFactory.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

////import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
////import "./IL2StandardERC20.sol";

contract L2StandardERC20 is IL2StandardERC20, ERC20 {
    address public l1Token;
    address public l2Bridge;

    /**
     * @param _l2Bridge Address of the L2 standard bridge.
     * @param _l1Token Address of the corresponding L1 token.
     * @param _name ERC20 name.
     * @param _symbol ERC20 symbol.
     */
    constructor(
        address _l2Bridge,
        address _l1Token,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        l1Token = _l1Token;
        l2Bridge = _l2Bridge;
    }

    modifier onlyL2Bridge() {
        require(msg.sender == l2Bridge, "Only L2 Bridge can mint and burn");
        _;
    }

    // slither-disable-next-line external-function
    function supportsInterface(bytes4 _interfaceId) public pure returns (bool) {
        bytes4 firstSupportedInterface = bytes4(keccak256("supportsInterface(bytes4)")); // ERC165
        bytes4 secondSupportedInterface = IL2StandardERC20.l1Token.selector ^
            IL2StandardERC20.mint.selector ^
            IL2StandardERC20.burn.selector;
        return _interfaceId == firstSupportedInterface || _interfaceId == secondSupportedInterface;
    }

    // slither-disable-next-line external-function
    function mint(address _to, uint256 _amount) public virtual onlyL2Bridge {
        _mint(_to, _amount);

        emit Mint(_to, _amount);
    }

    // slither-disable-next-line external-function
    function burn(address _from, uint256 _amount) public virtual onlyL2Bridge {
        _burn(_from, _amount);

        emit Burn(_from, _amount);
    }
}


/** 
 *  SourceUnit: /home/henry/fuse/fuse-l1/src/L2/messaging/L2StandardTokenFactory.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.9;

/* Contract ////Imports */
import { L2StandardERC20 } from "../../standards/L2StandardERC20.sol";
////import { Lib_PredeployAddresses } from "../../libraries/constants/Lib_PredeployAddresses.sol";

/**
 * @title L2StandardTokenFactory
 * @dev Factory contract for creating standard L2 token representations of L1 ERC20s
 * compatible with and working on the standard bridge.
 */
contract L2StandardTokenFactory {
    event StandardL2TokenCreated(address indexed _l1Token, address indexed _l2Token);

    /**
     * @dev Creates an instance of the standard ERC20 token on L2.
     * @param _l1Token Address of the corresponding L1 token.
     * @param _name ERC20 name.
     * @param _symbol ERC20 symbol.
     */
    function createStandardL2Token(
        address _l1Token,
        string memory _name,
        string memory _symbol
    ) external {
        require(_l1Token != address(0), "Must provide L1 token address");

        L2StandardERC20 l2Token = new L2StandardERC20(
            Lib_PredeployAddresses.L2_STANDARD_BRIDGE,
            _l1Token,
            _name,
            _symbol
        );

        emit StandardL2TokenCreated(_l1Token, address(l2Token));
    }
}

