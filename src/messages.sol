// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Address.sol";

library Messages {
    function messageHash(
        uint8 kind,
        address sender,
        uint256 blockNumber,
        uint256 timestamp,
        uint256 inboxSeqNum,
        uint256 gasPriceL1,
        bytes32 messageDataHash
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    kind,
                    sender,
                    blockNumber,
                    timestamp,
                    inboxSeqNum,
                    gasPriceL1,
                    messageDataHash
                )
            );
    }

    function addMessageToInbox(bytes32 inbox, bytes32 message) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(inbox, message));
    }
}
