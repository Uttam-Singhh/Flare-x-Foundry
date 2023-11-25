// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockFtsoRegistry} from "./mocks/MockFtsoRegistry.sol";

contract CounterTest is Test {
    FundMe public fundMe;
    address user = makeAddr("user");
    uint256 constant TEST_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        FundMeContractDeploy fundMeContractDeploy = new FundMeContractDeploy();
        fundMe = FundMeContractDeploy.run();
        vm.deal(user, STARTING_BALANCE);
        mockRegistry = MockFtsoRegistry();
    }

    function testvalueis1dollar() public { 
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
}
