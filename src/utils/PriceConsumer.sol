// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);
  function getRoundData(uint80 _roundId) external view returns (
    uint80 roundId,
    int256 answer,
    uint256 startedAt,
    uint256 updatedAt,
    uint80 answeredInRound
  );
  function latestRoundData() external view returns (
    uint80 roundId,
    int256 answer,
    uint256 startedAt,
    uint256 updatedAt,
    uint80 answeredInRound
  );
}

/**
 * @title PriceConsumer
 * @dev Contract that gets the latest price from a Chainlink Price Feed
 */
contract PriceConsumer {
    AggregatorV3Interface internal priceFeed;

    /**
     * @dev Constructor
     * @param _priceFeed Address of the price feed contract
     */
    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    /**
     * @dev Returns the latest price
     * @return Latest price from the price feed
     */
    function getLatestPrice() public view returns (int) {
        (
            /* uint80 roundID */,
            int price,
            /* uint startedAt */,
            /* uint timeStamp */,
            /* uint80 answeredInRound */
        ) = priceFeed.latestRoundData();
        return price;
    }

    /**
     * @dev Returns the decimals of the price feed
     * @return Decimals of the price feed
     */
    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }

    /**
     * @dev Returns the description of the price feed
     * @return Description of the price feed
     */
    function getDescription() public view returns (string memory) {
        return priceFeed.description();
    }
}