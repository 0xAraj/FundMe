//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    AggregatorV3Interface internal dataFeed;
    uint256 constant MIN_AMOUNT = 5;
    address immutable i_owner;
    address[] public s_funders;
    mapping(address funders => uint amount) public s_addressToAmount;

    constructor() {
        i_owner = payable(msg.sender);
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not owner!");
        _;
    }

    function getLatestData() public view returns (uint) {
        (, int priceInUSD, , , ) = dataFeed.latestRoundData();

        return uint(priceInUSD * 1e10);
    }

    function getPriceInUSD(uint amount) public view returns (uint) {
        uint ethPrice = getLatestData();
        uint amountInUSD = (ethPrice * amount) / 1e36;

        return amountInUSD;
    }

    function transfer() public payable {
        require(getPriceInUSD(msg.value) >= MIN_AMOUNT, "Not enough amount!");
        s_funders.push(msg.sender);
        s_addressToAmount[msg.sender] = msg.value;
    }

    function getVersion() public view returns (uint256) {
        uint256 version = dataFeed.version();
        return version;
    }

    function withdrawFunds() public onlyOwner {
        (bool success, ) = payable(i_owner).call{value: address(this).balance}(
            ""
        );
        require(success, "Transfer failed!");
    }
}
