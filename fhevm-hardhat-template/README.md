# FHEVM Hardhat Template

A complete Hardhat template for developing FHEVM (Fully Homomorphic Encryption Virtual Machine) smart contracts.

## Quick Start

### Prerequisites

- **Node.js**: Version 20 or higher
- **npm**: Package manager

### Installation

1. **Install dependencies**

   ```bash
   npm install
   ```

2. **Set up environment variables**

   ```bash
   npx hardhat vars set MNEMONIC
   npx hardhat vars set INFURA_API_KEY
   # Optional: Set Etherscan API key for contract verification
   npx hardhat vars set ETHERSCAN_API_KEY
   ```

3. **Compile contracts**

   ```bash
   npm run compile
   ```

4. **Run tests**

   ```bash
   npm run test
   ```

## Project Structure

```
.
├── contracts/          # Solidity smart contracts
├── deploy/            # Deployment scripts
├── scripts/           # Utility scripts
├── tasks/             # Hardhat tasks
├── test/              # Test files
├── hardhat.config.ts  # Hardhat configuration
└── package.json       # Project dependencies
```

## Available Scripts

| Script | Description |
|--------|-------------|
| `npm run compile` | Compile all contracts |
| `npm run test` | Run all tests |
| `npm run test:sepolia` | Run tests on Sepolia |
| `npm run lint` | Run all linters |
| `npm run clean` | Clean build artifacts |
| `npm run coverage` | Generate coverage report |

## Deployment

### Local Network

```bash
# Start local node
npx hardhat node

# Deploy contracts
npx hardhat deploy --network localhost
```

### Sepolia Testnet

```bash
# Deploy contracts
npx hardhat deploy --network sepolia

# Verify contract
npx hardhat verify --network sepolia <CONTRACT_ADDRESS>
```

## Documentation

- [FHEVM Documentation](https://docs.zama.ai/fhevm)
- [FHEVM Examples](https://docs.zama.org/protocol/examples)
- [FHEVM Hardhat Plugin](https://docs.zama.ai/protocol/solidity-guides/development-guide/hardhat)

## License

This project is licensed under the BSD-3-Clause-Clear License.

---

**Built with ❤️ using [FHEVM](https://github.com/zama-ai/fhevm) by Zama**
