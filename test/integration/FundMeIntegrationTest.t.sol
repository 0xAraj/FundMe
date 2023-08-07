//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeIntegrationTest is Test {
    FundMe fundMe;
    address FUNDER = makeAddr("funder");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(FUNDER, 10e18);
    }

    function testFundFundMe() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        console.log(address(fundMe).balance);
        assert(address(fundMe).balance == 10000000000000000);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        console.log(address(fundMe).balance);
        assert(address(fundMe).balance == 0);
    }
}
