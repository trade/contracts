// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/security/PausableUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "../interfaces/IMultiChainToken.sol";

/**
 * @title MultiChainTokenProxy
 * @dev Upgradeable version of MultiChainToken
 */
contract MultiChainTokenProxy is
    Initializable,
    ERC20Upgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    UUPSUpgradeable,
    IMultiChainToken
{
    bytes32 public constant BRIDGE_ROLE = keccak256("BRIDGE_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    // Chain ID of the current blockchain
    uint256 public currentChainId;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract
     * @param name_ Token name
     * @param symbol_ Token symbol
     * @param initialSupply Initial token supply
     */
    function initialize(string memory name_, string memory symbol_, uint256 initialSupply) public initializer {
        __ERC20_init(name_, symbol_);
        __AccessControl_init();
        __Pausable_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(BRIDGE_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);

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
    function receiveTokens(address _to, uint256 _amount, uint256 _fromChainId)
        external
        override
        whenNotPaused
        onlyRole(BRIDGE_ROLE)
    {
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

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
