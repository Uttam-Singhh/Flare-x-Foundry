// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockFtsoRegistry} from "./mocks/MockFtsoRegistry.sol";

contract CounterTest is Test {
    FundMe public fundMe;
    address user = makeAddr("user");
    uint256 constant TEST_VALUE = 6e18;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint8 public constant DECIMALS = 5;
    int256 public constant INITIAL_ANSWER = 1 * 10**18;
    string symbol = "testUSDC";
    uint256 public constant TIMESTAMP = 0;


    function setUp() public {
        
        fundMe = new FundMe;
        vm.deal(user, STARTING_BALANCE);
        mockRegistry = MockFtsoRegistry();
        
    }

     //////////////////////////
    ////// Price Tests //////
    ////////////////////////

    function testMockPrice() public {
        (uint256 price, uint256 timestamp, uint256 decimals) = mockRegistry.getCurrentPriceWithDecimals(symbol);
        assertEq(price, INITIAL_ANSWER);
        assertEq(decimals, DECIMALS);
        assertEq(timestamp, TIMESTAMP);
    }


 //////////////////////////
    ////// FundMe Tests //////
    ////////////////////////


    function testvalue() public { 
        assertEq(fundMe.MIN_FUND(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.expectRevert();
        vm.prank(user);
        fundMe.withdraw();
    }

    function testFundUpdates() external {
        vm.prank(user);
        fundMe.fund{value: TEST_VALUE}();

        uint256 fundedAmount = fundMe.getFundedAmount(USER);
        console.log(fundedAmount);
        assertEq(fundedAmount, TEST_VALUE);
    }

    // you can add more tests. for example testFundFails with less then min amount, etc.
}
