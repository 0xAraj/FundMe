//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address FUNDER = makeAddr("funder");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(FUNDER, 10e18);
    }

    function testMinAmountIsFiveDollar() public {
        uint amount = fundMe.MIN_AMOUNT();
        assertEq(amount, 5);
    }

    function testOwnerIsMsgSender() public {
        address owner = fundMe.i_owner();
        assertEq(owner, msg.sender);
    }

    function testVersionOfV3Aggregator() public {
        uint version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testTransferFundUpdate() public {
        vm.prank(FUNDER);
        fundMe.transferFunds{value: 1 ether}();

        address sender = fundMe.s_funders(0);
        uint amount = fundMe.s_addressToAmount(FUNDER);

        assertEq(sender, FUNDER);
        assertEq(amount, 1 ether);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(FUNDER);
        fundMe.transferFunds{value: 3 ether}();

        vm.expectRevert();
        vm.prank(FUNDER);
        fundMe.withdrawFunds();
    }

    function testWithdrawWhenSingleFunder() public {
        vm.prank(FUNDER);
        fundMe.transferFunds{value: 3 ether}();

        uint initialContractBalance = address(fundMe).balance;
        uint initialOwnerBalance = address(fundMe.i_owner()).balance;

        vm.prank(fundMe.i_owner());
        fundMe.withdrawFunds();

        uint finalContractBalance = address(fundMe).balance;
        uint finalOwnerBalance = address(fundMe.i_owner()).balance;

        assertEq(finalContractBalance, 0);
        assertEq(
            finalOwnerBalance,
            initialContractBalance + initialOwnerBalance
        );
    }

    function testWithdrawWhenMultipleFunder() public {
        for (uint160 i = 1; i < 10; i++) {
            hoax(address(i), 10e18);
            fundMe.transferFunds{value: 3 ether}();
        }

        uint initialContractBalance = address(fundMe).balance;
        console.log(initialContractBalance);
        uint initialOwnerBalance = address(fundMe.i_owner()).balance;

        vm.prank(fundMe.i_owner());
        fundMe.withdrawFunds();

        uint finalContractBalance = address(fundMe).balance;
        uint finalOwnerBalance = address(fundMe.i_owner()).balance;

        assertEq(finalContractBalance, 0);
        assertEq(
            finalOwnerBalance,
            initialContractBalance + initialOwnerBalance
        );
    }
}
