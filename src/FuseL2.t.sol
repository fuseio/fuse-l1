// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./FuseL2.sol";

contract FuseL2Test is DSTest {
    FuseL2 l;

    function setUp() public {
        l = new FuseL2();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
