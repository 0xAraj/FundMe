//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint constant amount = 0.01 ether;

    function fundFundMe(address mostRecentDeployedContract) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployedContract)).transferFunds{
            value: amount
        }();
        vm.stopBroadcast();
    }

    function run() external {
        // address mostRecentDeployedContract = DevOpsTools
        //     .get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(0x75A188Eb1547A5bD2E9022a7Ab1510709E65691F);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentDeployedContract) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployedContract)).withdrawFunds();
        vm.stopBroadcast();
    }

    function run() external {
        // address mostRecentDeployedContract = DevOpsTools
        //     .get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        withdrawFundMe(0x75A188Eb1547A5bD2E9022a7Ab1510709E65691F);
        vm.stopBroadcast();
    }
}
