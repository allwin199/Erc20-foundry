// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken myToken;

    address private bob = makeAddr("bob");
    address private alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100e18; //100 ether

    function setUp() external {
        DeployMyToken deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.startPrank(msg.sender);
        myToken.transfer(bob, STARTING_BALANCE);
        vm.stopPrank();
    }

    function test_InitialSupply_IsSet() public {
        uint256 initialSupply = myToken.totalSupply();
        assertEq(initialSupply, 1000e18);
    }

    function test_BobBalance() public {
        uint256 bobBalance = myToken.balanceOf(bob);
        assertEq(bobBalance, STARTING_BALANCE);
    }

    function test_TransferWorks() public {
        uint256 transferAmount = 1e18;

        vm.startPrank(msg.sender);
        myToken.transfer(alice, transferAmount);
        vm.stopPrank();

        uint256 aliceBalance = myToken.balanceOf(alice);
        assertEq(aliceBalance, transferAmount);
    }

    function test_Allowances_Works() public {
        uint256 intialAllowance = 1e18;
        vm.startPrank(bob);
        myToken.approve(alice, intialAllowance);
        vm.stopPrank();

        // since alice is granted allowance from bob
        // alice can give herself 1e18 onbehalf of bob
        vm.startPrank(alice);
        myToken.transferFrom(bob, alice, intialAllowance);
        vm.stopPrank();

        uint256 aliceBalance = myToken.balanceOf(alice);
        assertEq(aliceBalance, intialAllowance);

        uint256 bobBalance = myToken.balanceOf(bob);
        assertEq(bobBalance, STARTING_BALANCE - intialAllowance);
    }

    function test_Allowances_GivenToBob_ByOwner() public {
        uint256 intialAllowance = 1e18;
        vm.startPrank(msg.sender);
        myToken.approve(bob, intialAllowance);
        vm.stopPrank();

        uint256 bobsAllowance = myToken.allowance(msg.sender, bob);
        assertEq(bobsAllowance, intialAllowance);
    }

    function test_Allowances_Works_ForOwner() public {
        uint256 intialAllowance = 1e18;
        vm.startPrank(msg.sender);
        myToken.approve(bob, intialAllowance);
        vm.stopPrank();

        // since bob is granted allowance from the owner
        // bob can give anyone 1e18 onbehalf of owner
        vm.startPrank(bob);
        myToken.transferFrom(msg.sender, alice, intialAllowance);
        vm.stopPrank();

        uint256 aliceBalance = myToken.balanceOf(alice);
        assertEq(aliceBalance, intialAllowance);
    }
}
