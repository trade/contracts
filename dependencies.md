# Project Dependencies Reference

This file serves as a reference for the correct import paths and versions of dependencies used in this project. This helps maintain consistency and assists AI tools in providing accurate code suggestions.

## OpenZeppelin Contracts (v4.9.3)

### Standard Contracts

```solidity
// Token Standards
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// Access Control
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Security
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Utilities
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
```

### Upgradeable Contracts

```solidity
// Token Standards
import "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC20/extensions/ERC20PausableUpgradeable.sol";

// Access Control
import "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/access/AccessControlUpgradeable.sol";

// Security
import "@openzeppelin-upgradeable/contracts/security/PausableUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

// Proxy
import "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
```

### Proxy Contracts

```solidity
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
```

## Chainlink Contracts

```solidity
// Price Feeds
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// VRF (Verifiable Random Function)
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

// Automation (Keepers)
import "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";
```

## Foundry Remappings

These remappings are configured in `foundry.toml`:

```toml
remappings = [
    "@openzeppelin/=lib/openzeppelin-contracts/",
    "@openzeppelin-upgradeable/=lib/openzeppelin-contracts-upgradeable/",
    "@chainlink/=lib/chainlink-brownie-contracts/contracts/"
]
```

## Verification with Sourcify

### Using Forge

To verify contracts with Sourcify using Forge's built-in verification:

```bash
forge verify-contract --chain-id <CHAIN_ID> --compiler-version 0.8.20 <CONTRACT_ADDRESS> <CONTRACT_PATH>:<CONTRACT_NAME> --verifier sourcify
```

Example:
```bash
forge verify-contract --chain-id 11155111 --compiler-version 0.8.20 0x123abc... src/tokens/MultiChainToken.sol:MultiChainToken --verifier sourcify
```

### Using Custom Script

Alternatively, use our custom sourcify.sh script:

```bash
./sourcify.sh <CONTRACT_ADDRESS> <NETWORK> <CONTRACT_NAME>
```

Example:
```bash
./sourcify.sh 0x123abc... sepolia MultiChainToken
```