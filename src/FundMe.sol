//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {FundMeLibrary} from "./FundMeLibrary.sol";

contract FundMe {
    using FundMeLibrary for uint;
    AggregatorV3Interface internal dataFeed;
    uint256 constant MIN_AMOUNT = 5;
    address immutable i_owner;
    address[] public s_funders;
    mapping(address funders => uint amount) public s_addressToAmount;

    constructor(address priceFeed) {
        i_owner = payable(msg.sender);
        dataFeed = AggregatorV3Interface(priceFeed);
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not owner!");
        _;
    }

    function transfer() public payable {
        require(
            msg.value.getPriceInUSD(dataFeed) >= MIN_AMOUNT,
            "Not enough amount!"
        );
        s_funders.push(msg.sender);
        s_addressToAmount[msg.sender] = msg.value;
    }

    function getVersion() public view returns (uint256) {
        uint256 version = dataFeed.version();
        return version;
    }

    function withdrawFunds() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Transfer failed!");
    }

    receive() external payable {
        transfer();
    }
}
