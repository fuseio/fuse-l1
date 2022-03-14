// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.12;

import "./messages.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/* The set of smart contracts that enable validators to submit and store L2 state data is known as the rollup. The rollup is essentially a chain of blocks, so in other words, the rollup is the L2 chain. Note that the Arbitrum codebase refers to these blocks as ‘nodes’. However, to prevent confusion with the terms ‘validator nodes’ and ‘batcher nodes’, I will continue to refer to these rollup nodes as blocks throughout our codebase. */


contract Rollup {
    using SafeMath for uint256;
    mapping(uint256 => address) private _nodes;
    mapping(address => uint256) private _withdrawableFunds;

    struct Config {
        bytes32 machineHash;
        uint256 confirmPeriodBlocks;
        uint256 extraChallengeTimeBlocks;
        uint256 avmGasSpeedLimitPerBlock;
        uint256 baseStake;
        address stakeToken;
        address owner;
        address sequencer;
        uint256 sequencerDelayBlocks;
        uint256 sequencerDelaySeconds;
        bytes extraConfig;
    }

    struct ExecutionState {
        uint256 gasUsed;
        bytes32 machineHash;
        uint256 inboxCount;
        uint256 sendCount;
        uint256 logCount;
        bytes32 sendAcc;
        bytes32 logAcc;
        uint256 proposedBlock;
        uint256 inboxMaxCount;
    }

    function stateHash(ExecutionState memory execState) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    execState.gasUsed,
                    execState.machineHash,
                    execState.inboxCount,
                    execState.sendCount,
                    execState.logCount,
                    execState.sendAcc,
                    execState.logAcc,
                    execState.proposedBlock,
                    execState.inboxMaxCount
                )
            );
    }

    struct Assertion {
        ExecutionState beforeState;
        ExecutionState afterState;
    }

    function decodeExecutionState(
        bytes32[3] memory bytes32Fields,
        uint256[4] memory intFields,
        uint256 proposedBlock,
        uint256 inboxMaxCount
    ) internal pure returns (ExecutionState memory) {
        return
            ExecutionState(
                intFields[0],
                bytes32Fields[0],
                intFields[1],
                intFields[2],
                intFields[3],
                bytes32Fields[1],
                bytes32Fields[2],
                proposedBlock,
                inboxMaxCount
            );
    }

    function decodeAssertion(
        bytes32[3][2] memory bytes32Fields,
        uint256[4][2] memory intFields,
        uint256 beforeProposedBlock,
        uint256 beforeInboxMaxCount,
        uint256 inboxMaxCount
    ) internal view returns (Assertion memory) {
        return
            Assertion(
                decodeExecutionState(
                    bytes32Fields[0],
                    intFields[0],
                    beforeProposedBlock,
                    beforeInboxMaxCount
                ),
                decodeExecutionState(bytes32Fields[1], intFields[1], block.number, inboxMaxCount)
            );
    }

    // function executionStateChallengeHash(ExecutionState memory state)
    //     internal
    //     pure
    //     returns (bytes32)
    // {
    //     return
    //         ChallengeLib.assertionHash(
    //             state.gasUsed,
    //             ChallengeLib.assertionRestHash(
    //                 state.inboxCount,
    //                 state.machineHash,
    //                 state.sendAcc,
    //                 state.sendCount,
    //                 state.logAcc,
    //                 state.logCount
    //             )
    //         );
    // }

    // function executionHash(Assertion memory assertion) internal pure returns (bytes32) {
    //     return
    //         ChallengeLib.bisectionChunkHash(
    //             assertion.beforeState.gasUsed,
    //             assertion.afterState.gasUsed - assertion.beforeState.gasUsed,
    //             executionStateChallengeHash(assertion.beforeState),
    //             executionStateChallengeHash(assertion.afterState)
    //         );
    // }

    function assertionGasUsed(Assertion memory assertion)
        internal
        pure
        returns (uint256)
    {
        return assertion.afterState.gasUsed.sub(assertion.beforeState.gasUsed);
    }

    function challengeRoot(
        Assertion memory assertion,
        bytes32 assertionExecHash,
        uint256 blockProposed
    ) internal pure returns (bytes32) {
        return challengeRootHash(assertionExecHash, blockProposed, assertion.afterState.inboxCount);
    }

    function challengeRootHash(
        bytes32 execution,
        uint256 proposedTime,
        uint256 maxMessageCount
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(execution, proposedTime, maxMessageCount));
    }

    function confirmHash(Assertion memory assertion) internal pure returns (bytes32) {
        return
            confirmHash(
                assertion.beforeState.sendAcc,
                assertion.afterState.sendAcc,
                assertion.afterState.logAcc,
                assertion.afterState.sendCount,
                assertion.afterState.logCount
            );
    }

    function confirmHash(
        bytes32 beforeSendAcc,
        bytes32 afterSendAcc,
        bytes32 afterLogAcc,
        uint256 afterSendCount,
        uint256 afterLogCount
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    beforeSendAcc,
                    afterSendAcc,
                    afterSendCount,
                    afterLogAcc,
                    afterLogCount
                )
            );
    }

    function feedAccumulator(
        bytes memory messageData,
        uint256[] memory messageLengths,
        bytes32 beforeAcc
    ) internal pure returns (bytes32) {
        uint256 offset = 0;
        uint256 messageCount = messageLengths.length;
        uint256 dataLength = messageData.length;
        bytes32 messageAcc = beforeAcc;
        for (uint256 i = 0; i < messageCount; i++) {
            uint256 messageLength = messageLengths[i];
            require(offset + messageLength <= dataLength, "DATA_OVERRUN");
            bytes32 messageHash;
            assembly {
                messageHash := keccak256(add(messageData, add(offset, 32)), messageLength)
            }
            messageAcc = keccak256(abi.encodePacked(messageAcc, messageHash));
            offset += messageLength;
        }
        require(offset == dataLength, "DATA_LENGTH");
        return messageAcc;
    }

    function nodeHash(
        bool hasSibling,
        bytes32 lastHash,
        bytes32 assertionExecHash,
        bytes32 inboxAcc
    ) internal pure returns (bytes32) {
        uint8 hasSiblingInt = hasSibling ? 1 : 0;
        return keccak256(abi.encodePacked(hasSiblingInt, lastHash, assertionExecHash, inboxAcc));
    }

    constructor(address initialNode) {
        _nodes[0] = initialNode;
    }

    /**
     * @notice Get the address of the Node contract for the given node
     * @param nodeNum Index of the node
     * @return Address of the Node contract
     */
    function getNode(uint256 nodeNum) public view returns (address) {
        return _nodes[nodeNum];
    }

    /**
     * @notice Get the amount of funds withdrawable by the given address
     * @param owner Address to check the funds of
     * @return Amount of funds withdrawable by owner
     */
    function withdrawableFunds(address owner) external view returns (uint256) {
        return _withdrawableFunds[owner];
    }
}
