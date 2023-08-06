//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint constant amount = 0.01 ether;

    function fundFundMe(address mostRecentDeployedContract) public {
        FundMe(payable(mostRecentDeployedContract)).transferFunds{
            value: amount
        }();
    }

    function run() external {
        address mostRecentDeployedContract = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeployedContract);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentDeployedContract) public {
        FundMe(payable(mostRecentDeployedContract)).withdrawFunds();
    }

    function run() external {
        address mostRecentDeployedContract = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        withdrawFundMe(mostRecentDeployedContract);
        vm.stopBroadcast();
    }
}
