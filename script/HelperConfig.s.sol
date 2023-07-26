//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "./Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address networkAddress;
    }
    NetworkConfig public activeNetwork;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaConfig();
        } else {
            activeNetwork = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            networkAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetwork.networkAddress != address(0)) {
            return activeNetwork;
        }
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8, 2e18);
        NetworkConfig memory anvilConfig = NetworkConfig(
            address(mockV3Aggregator)
        );
        return anvilConfig;
    }
}
