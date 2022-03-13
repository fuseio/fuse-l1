// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.12;

import "./messages.sol";

/* We are using only one kind of Inbox, the sequencer one, so I will call this contract 'Inbox' for the sake
of simplicity. [note that Abitrum is using also a delayed-inbox]. This Inbox sits on L1 are receive transaction from the sequecner server
The sequencer inbox is the primary contract where every validator pulls in the latest L2 transaction data. Note that we copied
the addSequencerL2BatchImpl but didn't add the delayedMessages grabber at the end of the function, once that for us,
we only want to add messages from the sequencer.
*/

// This is a Sequencer Inbox in arbitrum codebase
contract Inbox {
    event SequencerBatchDelivered(
        uint256 indexed firstMessageNum,
        bytes32 indexed beforeAcc,
        uint256 newMessageCount,
        bytes32 afterAcc,
        bytes transactions,
        uint256[] lengths,
        uint256[] sectionsMetadata,
        uint256 seqBatchIndex,
        address sequencer
    );

    event SequencerBatchDeliveredFromOrigin(
        uint256 indexed firstMessageNum,
        bytes32 indexed beforeAcc,
        uint256 newMessageCount,
        bytes32 afterAcc,
        uint256 seqBatchIndex
    );

    event DelayedInboxForced(
        uint256 indexed firstMessageNum,
        bytes32 indexed beforeAcc,
        uint256 newMessageCount,
        uint256 totalDelayedMessagesRead,
        bytes32[2] afterAccAndDelayed,
        uint256 seqBatchIndex
    );

    // count of messages read from the delayedInbox
    uint256 public totalDelayedMessagesRead;
    /// Number of messages included in the sequencer-inbox; tracked seperately from inboxAccs since multiple messages 
    /// can be included in a single inboxAcc update (i.e., many messages in a batch, many batches in a single inboxAccs update, etc)
    uint256 public messageCount;

    bytes32[] public inboxAccs;
    address public rollup;
    mapping(address => bool) public isSequencer;
    // Window in which only the Sequencer can update the Inbox; 
    // this delay is what allows the Sequencer to give receipts with sub-blocktime latency.
    uint256 public maxDelayBlocks;
    uint256 public maxDelaySeconds;


    constructor(address _sequencer, address _rollup) {
        isSequencer[_sequencer] = true;
        rollup = _rollup;
    }

    /**
     * @notice Sequencer adds a batch to inbox.
     * @param transactions concatenated bytes of L2 messages
     * @param lengths length of each txn in transctions (for parsing)
     * @param sectionsMetadata Each consists of [numItems, l1BlockNumber, l1Timestamp, newTotalDelayedMessagesRead, newDelayedAcc]
     * @param afterAcc Expected inbox hash after batch is added
     * @dev sectionsMetadata lets the sequencer delineate new l1Block numbers and l1Timestamps within a given batch; 
     * this lets the sequencer minimize the number of batches created (and thus amortizing cost) while still giving timely receipts
     */
    function addSequencerL2Batch(
        bytes calldata transactions,
        uint256[] calldata lengths,
        uint256[] calldata sectionsMetadata,
        bytes32 afterAcc
    ) external {
        uint256 startNum = messageCount;
        bytes32 beforeAcc = addSequencerL2BatchImpl(
            transactions,
            lengths,
            sectionsMetadata,
            afterAcc
        );
        emit SequencerBatchDelivered(
            startNum,
            beforeAcc,
            messageCount,
            afterAcc,
            transactions,
            lengths,
            sectionsMetadata,
            inboxAccs.length - 1,
            msg.sender
        );
    }

    function setMaxDelay(uint256 newMaxDelayBlocks, uint256 newMaxDelaySeconds) external {
        require(msg.sender == rollup, "ONLY_ROLLUP");
        maxDelayBlocks = newMaxDelayBlocks;
        maxDelaySeconds = newMaxDelaySeconds;
        // emit MaxDelayUpdated(newMaxDelayBlocks, newMaxDelaySeconds);
    }

    /**
     * @notice Sequencer adds a batch to inbox.
     * @param transactions concatenated bytes of L2 messages
     * @param lengths length of each txn in transctions (for parsing)
     * @param sectionsMetadata Each consists of [numItems, l1BlockNumber, l1Timestamp, newTotalDelayedMessagesRead, newDelayedAcc]
     * @param afterAcc Expected inbox hash after batch is added
     * @dev sectionsMetadata lets the sequencer delineate new l1Block numbers and l1Timestamps within a given batch; 
     * this lets the sequencer minimize the number of batches created (and thus amortizing cost) while still giving timely receipts
     */
    function addSequencerL2BatchImpl(
        bytes memory transactions,
        uint256[] calldata lengths,
        uint256[] calldata sectionsMetadata,
        bytes32 afterAcc
    ) private returns (bytes32 beforeAcc) {
        // require(isSequencer[msg.sender], "ONLY_SEQUENCER");

        if (inboxAccs.length > 0) {
            beforeAcc = inboxAccs[inboxAccs.length - 1];
        }

        uint256 runningCount = messageCount;
        bytes32 runningAcc = beforeAcc;
        uint256 processedItems = 0;
        uint256 dataOffset;
        assembly {
            dataOffset := add(transactions, 32)
        }
        for (uint256 i = 0; i + 5 <= sectionsMetadata.length; i += 5) {
            // Each metadata section consists of:
            // [numItems, l1BlockNumber, l1Timestamp, newTotalDelayedMessagesRead, newDelayedAcc]
            {
                uint256 l1BlockNumber = sectionsMetadata[i + 1];
                require(l1BlockNumber + maxDelayBlocks >= block.number, "BLOCK_TOO_OLD");
                require(l1BlockNumber <= block.number, "BLOCK_TOO_NEW");
            }
            {
                uint256 l1Timestamp = sectionsMetadata[i + 2];
                require(l1Timestamp + maxDelaySeconds >= block.timestamp, "TIME_TOO_OLD");
                require(l1Timestamp <= block.timestamp, "TIME_TOO_NEW");
            }

            {
                bytes32 prefixHash = keccak256(
                    abi.encodePacked(msg.sender, sectionsMetadata[i + 1], sectionsMetadata[i + 2])
                );
                uint256 numItems = sectionsMetadata[i];
                (runningAcc, runningCount, dataOffset) = calcL2Batch(
                    dataOffset,
                    lengths,
                    processedItems,
                    numItems,
                    prefixHash,
                    runningCount,
                    runningAcc
                );
                processedItems += numItems;
            }

            // uint256 newTotalDelayedMessagesRead = sectionsMetadata[i + 3];
            // require(newTotalDelayedMessagesRead >= totalDelayedMessagesRead, "DELAYED_BACKWARDS");
            // require(newTotalDelayedMessagesRead >= 1, "MUST_DELAYED_INIT");
            // require(
            //     totalDelayedMessagesRead >= 1 || sectionsMetadata[i] == 0,
            //     "MUST_DELAYED_INIT_START"
            // );
            // // Sequencer decides how many messages (if any) to include from the delayed inbox
            // if (newTotalDelayedMessagesRead > totalDelayedMessagesRead) {
            //     (runningAcc, runningCount) = includeDelayedMessages(
            //         runningAcc,
            //         runningCount,
            //         newTotalDelayedMessagesRead,
            //         sectionsMetadata[i + 1], // block number
            //         sectionsMetadata[i + 2], // timestamp
            //         bytes32(sectionsMetadata[i + 4]) // delayed accumulator
            //     );
            // }
        }

        uint256 startOffset;
        assembly {
            startOffset := add(transactions, 32)
        }
        require(dataOffset >= startOffset, "OFFSET_OVERFLOW");
        require(dataOffset <= startOffset + transactions.length, "TRANSACTIONS_OVERRUN");

        require(runningCount > messageCount, "EMPTY_BATCH");
        inboxAccs.push(runningAcc);
        messageCount = runningCount;

        require(runningAcc == afterAcc, "AFTER_ACC");
    }



    function calcL2Batch(
        uint256 beforeOffset,
        uint256[] calldata lengths,
        uint256 lengthsOffset,
        uint256 itemCount,
        bytes32 prefixHash,
        uint256 beforeCount,
        bytes32 beforeAcc
    )
        private
        pure
        returns (
            bytes32 acc,
            uint256 count,
            uint256 offset
        )
    {
        offset = beforeOffset;
        count = beforeCount;
        acc = beforeAcc;
        itemCount += lengthsOffset;
        for (uint256 i = lengthsOffset; i < itemCount; i++) {
            uint256 length = lengths[i];
            bytes32 messageDataHash;
            assembly {
                messageDataHash := keccak256(offset, length)
            }
            acc = keccak256(abi.encodePacked(acc, count, prefixHash, messageDataHash));
            offset += length;
            count++;
        }
        return (acc, count, offset);
    }
}
