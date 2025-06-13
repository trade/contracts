// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IMultiChainToken
 * @dev Interface for a token that can be used across multiple chains
 */
interface IMultiChainToken {
    /**
     * @dev Emitted when tokens are bridged to another chain
     */
    event TokensBridged(address indexed from, uint256 amount, uint256 indexed toChainId);
    
    /**
     * @dev Emitted when tokens are received from another chain
     */
    event TokensReceived(address indexed to, uint256 amount, uint256 indexed fromChainId);
    
    /**
     * @dev Bridge tokens to another chain
     * @param _amount Amount of tokens to bridge
     * @param _toChainId Destination chain ID
     */
    function bridgeTokens(uint256 _amount, uint256 _toChainId) external;
    
    /**
     * @dev Receive tokens from another chain
     * @param _to Address to receive tokens
     * @param _amount Amount of tokens to receive
     * @param _fromChainId Source chain ID
     */
    function receiveTokens(address _to, uint256 _amount, uint256 _fromChainId) external;
}