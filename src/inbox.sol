// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.12;

import "./messages.sol";

/* We are using only one kind of Inbox, the sequencer one, so I will call this contract 'Inbox' for the sake
of simplicity. [note that Abitrum is using also a delayed-inbox]. This Inbox sits on L1 are receive transaction from the sequecner server
*/

contract Inbox {
}
