//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library FundMeLibrary {
    function getLatestData(
        AggregatorV3Interface dataFeed
    ) internal view returns (uint) {
        (, int priceInUSD, , , ) = dataFeed.latestRoundData();

        return uint(priceInUSD * 1e10);
    }

    function getPriceInUSD(
        uint amount,
        AggregatorV3Interface dataFeed
    ) internal view returns (uint) {
        uint ethPrice = getLatestData(dataFeed);
        uint amountInUSD = (ethPrice * amount) / 1e36;

        return amountInUSD;
    }
}
