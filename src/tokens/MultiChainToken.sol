// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../interfaces/IMultiChainToken.sol";

/**
 * @title MultiChainToken
 * @dev ERC20 token with multichain capabilities
 */
contract MultiChainToken is ERC20, AccessControl, Pausable, IMultiChainToken {
    bytes32 public constant BRIDGE_ROLE = keccak256("BRIDGE_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    
    // Chain ID of the current blockchain
    uint256 public immutable currentChainId;
    
    /**
     * @dev Constructor
     * @param name_ Token name
     * @param symbol_ Token symbol
     * @param initialSupply Initial token supply
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply
    ) ERC20(name_, symbol_) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(BRIDGE_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        
        _mint(msg.sender, initialSupply);
        
        currentChainId = block.chainid;
    }
    
    /**
     * @dev Bridge tokens to another chain
     * @param _amount Amount of tokens to bridge
     * @param _toChainId Destination chain ID
     */
    function bridgeTokens(uint256 _amount, uint256 _toChainId) external override whenNotPaused {
        require(_amount > 0, "Amount must be greater than 0");
        require(_toChainId != currentChainId, "Cannot bridge to the same chain");
        
        // Burn tokens on this chain
        _burn(msg.sender, _amount);
        
        // Emit event for off-chain bridge to pick up
        emit TokensBridged(msg.sender, _amount, _toChainId);
    }
    
    /**
     * @dev Receive tokens from another chain
     * @param _to Address to receive tokens
     * @param _amount Amount of tokens to receive
     * @param _fromChainId Source chain ID
     */
    function receiveTokens(address _to, uint256 _amount, uint256 _fromChainId) external override whenNotPaused onlyRole(BRIDGE_ROLE) {
        require(_to != address(0), "Invalid recipient address");
        require(_amount > 0, "Amount must be greater than 0");
        require(_fromChainId != currentChainId, "Cannot receive from the same chain");
        
        // Mint tokens on this chain
        _mint(_to, _amount);
        
        emit TokensReceived(_to, _amount, _fromChainId);
    }
    
    /**
     * @dev Pause token transfers
     */
    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }
    
    /**
     * @dev Unpause token transfers
     */
    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }
    
    /**
     * @dev Hook that is called before any transfer of tokens
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }
}