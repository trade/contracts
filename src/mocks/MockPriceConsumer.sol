// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title MockPriceConsumer
 * @dev Mock implementation of price consumer for testing
 */
contract MockPriceConsumer {
    int256 private mockPrice;
    uint8 private mockDecimals;

    constructor() {
        mockPrice = 200000000000; // $2000.00000000 with 8 decimals
        mockDecimals = 8;
    }

    function getLatestPrice() external view returns (int256) {
        return mockPrice;
    }

    function getDecimals() external view returns (uint8) {
        return mockDecimals;
    }

    function setMockPrice(int256 _price) external {
        mockPrice = _price;
    }

    function setMockDecimals(uint8 _decimals) external {
        mockDecimals = _decimals;
    }
}
