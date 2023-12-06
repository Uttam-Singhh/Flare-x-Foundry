// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockFtsoRegistry} from "./mocks/MockFtsoRegistry.sol";

contract CounterTest is Test {
    MockFtsoRegistry mockRegistry;
    FundMe public fundMe;
    address user = makeAddr("user");
    uint256 constant TEST_VALUE = 8 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    string symbol = "C2FLR";

    function setUp() public {
        fundMe = new FundMe();
        vm.deal(user, STARTING_BALANCE);
        mockRegistry = new MockFtsoRegistry();
        mockRegistry.setPriceForSymbol("C2FLR", 1e18, 0, 5);
    }

    //////////////////////////
    ////// Price Tests /////
    ////////////////////////

    function testMockPrice() public {
        (uint256 price, uint256 timestamp, uint256 decimals) = mockRegistry
            .getCurrentPriceWithDecimals(symbol);
        assertTrue(price == 1e18);
        assertTrue(decimals == 5);
        assertTrue(timestamp == 0);
    }

    //////////////////////////
    ////// FundMe Tests /////
    ////////////////////////

    function testvalue() public {
        assertEq(fundMe.MIN_FUND(), 1e18);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.expectRevert();
        vm.prank(user);
        fundMe.withdraw();
    }

}  //I have added only a few testcases, you can simply add more test cases like testFundFails with less then min amount, etc. the more the better!
