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
    string symbol = "testUSDC";
    

    function setUp() public {
        fundMe = new FundMe();
        vm.deal(user, STARTING_BALANCE);
        mockRegistry = new MockFtsoRegistry();
        mockRegistry.setPriceForSymbol("testUSDC", 1e18, 0, 5);
    }

     //////////////////////////
    ////// Price Tests //////
    ////////////////////////

    function testMockPrice() public {
        (uint256 price, uint256 timestamp, uint256 decimals) = mockRegistry.getCurrentPriceWithDecimals(symbol);
        assertTrue(price == 1e18);
        assertEq(decimals, 5);
        assertEq(timestamp, 0);
    }


 //////////////////////////
    ////// FundMe Tests //////
    ////////////////////////


    function testvalue() public { 
        assertEq(fundMe.MIN_FUND(), 5e18);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.expectRevert();
        vm.prank(user);
        fundMe.withdraw();
    }

    function testFundUpdates() external {
        vm.prank(user);
        fundMe.fund{value: TEST_VALUE}();

        vm.prank(user);
        uint256 fundedAmount = fundMe.getAmountFunded(user);
        console2.log(fundedAmount);
        assertEq(fundedAmount, TEST_VALUE);
    }

    // you can add more tests. for example testFundFails with less then min amount, etc.
}
