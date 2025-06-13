# Foundry Contracts Template

A modern, well-structured template for Solidity smart contract development using Foundry.

## Features

- Organized project structure following best practices
- Standard and upgradeable contract implementations
- Role-based access control patterns
- Security features (Pausable, ReentrancyGuard)
- External integrations (Chainlink)
- Comprehensive test suite
- Sourcify and Etherscan verification
- CI/CD workflows

## Project Structure

```
src/
├── interfaces/     # Contract interfaces
├── tokens/         # Token implementations
├── proxy/          # Upgradeable contract implementations
├── utils/          # Utility contracts
└── mocks/          # Mock contracts for testing
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/contracts-template.git
cd contracts-template
```

2. Install dependencies:
```bash
forge install
```

## Testing

Run tests:
```bash
forge test
```

Run tests with gas reporting:
```bash
forge test --gas-report
```

Run tests with coverage:
```bash
forge coverage
```

## Local Development

1. Start a local Anvil chain:
```bash
anvil
```

2. Deploy to local chain:
```bash
forge script script/MultiChainToken.s.sol:DeployMultiChainToken --rpc-url anvil --broadcast
```

## Deployment

1. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your RPC URLs, private key, and API keys
```

2. Deploy contracts:
```bash
# For testnet
forge script script/MultiChainToken.s.sol:DeployMultiChainToken --rpc-url testnet --broadcast

# For mainnet
forge script script/MultiChainToken.s.sol:DeployMultiChainToken --rpc-url mainnet --broadcast
```

3. Verify contracts on Sourcify (decentralized verification):
```bash
./sourcify.sh <DEPLOYED_ADDRESS> <NETWORK> MultiChainToken
```

## Contract Verification

### Contract Verification

#### Primary: Sourcify Verification (Decentralized)

Always verify contracts on Sourcify first for decentralized and immutable verification:

```bash
./sourcify.sh <CONTRACT_ADDRESS> <NETWORK> <CONTRACT_NAME>
```

Example:
```bash
./sourcify.sh 0x123abc... sepolia MultiChainToken
```

You can also use Foundry's built-in Sourcify verification:
```bash
forge verify-contract --chain-id <CHAIN_ID> --compiler-version 0.8.20 <CONTRACT_ADDRESS> src/tokens/MultiChainToken.sol:MultiChainToken --verifier sourcify
```

#### Secondary: Etherscan Verification (Centralized)

After Sourcify verification, you can also verify on centralized block explorers:

```bash
forge verify-contract --chain-id <CHAIN_ID> --compiler-version 0.8.20 <CONTRACT_ADDRESS> src/tokens/MultiChainToken.sol:MultiChainToken --etherscan-api-key <YOUR_API_KEY>
```

## Development Guidelines

This project follows SOLID principles and best practices for smart contract development:

- **Single Responsibility**: Each contract has a single purpose
- **Open/Closed**: Contracts are designed for extension without modification
- **Liskov Substitution**: Derived contracts maintain the behavior of base contracts
- **Interface Segregation**: Interfaces are focused and minimal
- **Dependency Inversion**: Contracts depend on abstractions, not implementations

## License

This project is licensed under the MIT License.