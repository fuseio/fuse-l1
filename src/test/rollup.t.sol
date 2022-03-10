// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.12;

import "ds-test/test.sol";

import "../rollup.sol";

contract RollupTest is DSTest {
    Rollup r;

    function setUp() public {
        r = new Rollup();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
