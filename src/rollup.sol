// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Address.sol";
import "./messages.sol";

/* The set of smart contracts that enable validators to submit and store L2 state data is known as the rollup. The rollup is essentially a chain of blocks, so in other words, the rollup is the L2 chain. Note that the Arbitrum codebase refers to these blocks as ‘nodes’. However, to prevent confusion with the terms ‘validator nodes’ and ‘batcher nodes’, I will continue to refer to these rollup nodes as blocks throughout our codebase. */


contract Rollup {
}
