# FHEVM Examples Hub

> **Zama Bounty Track - December 2025**
> A comprehensive collection of standalone FHEVM examples demonstrating privacy-preserving smart contracts using Fully Homomorphic Encryption

[![License: BSD-3-Clause-Clear](https://img.shields.io/badge/License-BSD--3--Clause--Clear-blue.svg)](LICENSE)
[![Hardhat](https://img.shields.io/badge/Built%20with-Hardhat-yellow)](https://hardhat.org/)
[![FHEVM](https://img.shields.io/badge/Powered%20by-FHEVM-blue)](https://docs.zama.ai/fhevm)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Available Examples](#available-examples)
- [Automation Tools](#automation-tools)
- [Documentation](#documentation)
- [Competition Submission](#competition-submission)
- [Resources](#resources)

---

## Overview

**FHEVM Examples Hub** is a comprehensive repository of standalone FHEVM example projects, each demonstrating specific concepts and patterns for building privacy-preserving smart contracts using Fully Homomorphic Encryption.

### What Makes This Special?

- **🎓 Educational**: Each example focuses on teaching one clear concept
- **🔨 Standalone**: Every example can be generated as an independent repository
- **🤖 Automated**: CLI tools for scaffolding new examples and generating documentation
- **📚 Well-Documented**: Comprehensive guides with code annotations and anti-patterns
- **✅ Production-Ready**: Real-world patterns and best practices

---

## Features

### ✅ Bounty Requirements Met

- **Standalone Examples**: Each example is a complete, independent Hardhat project
- **Base Template**: Reusable template for all FHEVM projects
- **Automation Scripts**: TypeScript CLI tools for generating examples and documentation
- **Comprehensive Tests**: Full test coverage with success and failure scenarios
- **GitBook Documentation**: Auto-generated docs from code annotations
- **Developer Guide**: Complete guide for adding new examples

### 🎯 Example Categories

#### Basic Examples
- **FHE Counter**: Simple encrypted counter demonstrating basic operations
- **Encrypt Single Value**: Encryption mechanism and common pitfalls
- **Encrypt Multiple Values**: Batch encryption patterns
- **User Decryption**: User-side decryption with permissions
- **Public Decryption**: Async decryption workflows

#### Advanced Examples
- **Privacy Pharmaceutical Procurement** (Flagship): Complete pharmaceutical supply chain with:
  - Encrypted order creation
  - Private bid submission
  - Encrypted supplier matching
  - Selective decryption
  - Reputation management

---

## Quick Start

### Prerequisites

- **Node.js**: Version 20 or higher
- **npm**: Package manager
- **Git**: Version control

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd PrivacyPharma

# Install dependencies (for automation tools)
npm install
```

### Generate Your First Example

```bash
# Generate a standalone FHE Counter example
ts-node scripts/create-fhevm-example.ts fhe-counter ./my-fhe-counter

# Navigate to the generated project
cd my-fhe-counter

# Install, compile, and test
npm install
npm run compile
npm run test
```

### Generate Advanced Example

```bash
# Generate the Privacy Pharmaceutical example
ts-node scripts/create-fhevm-example.ts privacy-pharmaceutical ./my-pharma-project

cd my-pharma-project
npm install
npm run compile
npm run test
```

---

## Project Structure

```
PrivacyPharma/                    # FHEVM Examples Hub
│
├── fhevm-hardhat-template/       # ⚙️ Base Hardhat Template
│   ├── contracts/                # Template contracts
│   ├── test/                     # Template tests
│   ├── deploy/                   # Deployment scripts
│   ├── hardhat.config.ts         # Hardhat configuration
│   └── package.json              # Dependencies
│
├── contracts/                    # 📁 All Example Contracts
│   ├── basic/                    # Basic FHEVM examples
│   │   ├── FHECounter.sol
│   │   ├── encrypt/              # Encryption patterns
│   │   ├── decrypt/              # Decryption patterns
│   │   └── operations/           # FHE operations
│   └── advanced/                 # Advanced examples
│       └── PrivacyPharma.sol     # Flagship example
│
├── test/                         # 🧪 All Test Files
│   ├── basic/                    # Basic example tests
│   └── advanced/                 # Advanced example tests
│
├── scripts/                      # 🤖 Automation Tools
│   ├── create-fhevm-example.ts   # Generate standalone repos
│   ├── generate-docs.ts          # Generate documentation
│   └── deploy.js                 # Legacy deployment
│
├── examples/                     # 📚 Generated Documentation
│   ├── SUMMARY.md                # Documentation index
│   └── *.md                      # Individual guides
│
├── README.md                     # This file
├── DEVELOPER_GUIDE.md            # Guide for contributors
└── COMPETITION_SUBMISSION.md     # Bounty submission details
```

---

## Available Examples

### Basic Examples

#### 1. FHE Counter
**Path**: `contracts/basic/FHECounter.sol`

A simple encrypted counter demonstrating:
- Encrypted data types (`euint32`)
- FHE operations (`FHE.add`, `FHE.sub`)
- Access control (`FHE.allow`, `FHE.allowThis`)
- Input proof validation

**Generate:**
```bash
ts-node scripts/create-fhevm-example.ts fhe-counter ./output/fhe-counter
```

---

#### 2. Encrypt Single Value
**Path**: `contracts/basic/encrypt/EncryptSingleValue.sol`

Demonstrates encryption fundamentals:
- Converting plaintext to encrypted values
- Input proof patterns
- Common pitfalls (missing `allowThis`)
- Anti-patterns to avoid

**Generate:**
```bash
ts-node scripts/create-fhevm-example.ts encrypt-single-value ./output/encrypt-single
```

---

#### 3. Encrypt Multiple Values
**Path**: `contracts/basic/encrypt/EncryptMultipleValues.sol`

Shows batch encryption patterns:
- Handling multiple encrypted values
- Combined proof optimization
- Struct storage patterns
- Permission management for multiple values

**Generate:**
```bash
ts-node scripts/create-fhevm-example.ts encrypt-multiple-values ./output/encrypt-multiple
```

---

### Advanced Examples

#### Privacy Pharmaceutical Procurement (Flagship)
**Path**: `contracts/advanced/PrivacyPharma.sol`

A production-ready pharmaceutical procurement system featuring:

**Core Features:**
- 🔐 **Encrypted Orders**: Buyers create orders with encrypted drug IDs, quantities, and budgets
- 💰 **Private Bidding**: Suppliers submit encrypted bids
- 🧮 **Private Matching**: Smart contract finds best supplier without seeing actual prices
- 🎯 **Selective Reveal**: Only winning supplier learns order details
- ⭐ **Reputation System**: Encrypted supplier reputation tracking

**FHEVM Concepts Demonstrated:**
- **Chapter: Encryption** - `euint32`, `euint64` encrypted types
- **Chapter: Access Control** - Fine-grained permission management
- **Chapter: Private Computation** - FHE comparisons and conditional logic
- **Chapter: Public Decryption** - Async decryption workflow
- **Chapter: Handles** - Understanding encrypted value lifecycle

**Generate:**
```bash
ts-node scripts/create-fhevm-example.ts privacy-pharmaceutical ./output/privacy-pharma
```

**Use Cases:**
- Pharmaceutical supply chain privacy
- Sealed-bid auctions
- Private procurement systems
- Encrypted RFQ platforms

**Test Coverage:**
- 15+ comprehensive tests
- Full lifecycle testing
- Edge cases and anti-patterns
- Integration scenarios

[→ View Full Documentation](examples/privacy-pharmaceutical.md)

---

## Automation Tools

### 1. create-fhevm-example.ts

Generates complete standalone FHEVM example repositories.

**Usage:**
```bash
ts-node scripts/create-fhevm-example.ts <example-name> [output-dir]
```

**What It Does:**
1. ✅ Clones base Hardhat template
2. ✅ Copies specified contract and tests
3. ✅ Updates configuration files
4. ✅ Generates custom README
5. ✅ Creates deployment scripts
6. ✅ Produces ready-to-use standalone repository

**Example:**
```bash
ts-node scripts/create-fhevm-example.ts fhe-counter ./my-project
cd my-project
npm install && npm run compile && npm run test
```

**Available Examples:**
- `fhe-counter` - Basic encrypted counter
- `encrypt-single-value` - Single value encryption
- `encrypt-multiple-values` - Batch encryption
- `privacy-pharmaceutical` - Advanced pharmaceutical procurement

---

### 2. generate-docs.ts

Creates GitBook-formatted documentation from contracts and tests.

**Usage:**
```bash
# Single example
ts-node scripts/generate-docs.ts <example-name>

# All examples
ts-node scripts/generate-docs.ts --all
```

**What It Does:**
1. ✅ Extracts contract and test code
2. ✅ Generates formatted markdown
3. ✅ Updates SUMMARY.md index
4. ✅ Organizes by category

**Example:**
```bash
ts-node scripts/generate-docs.ts privacy-pharmaceutical
# Output: examples/privacy-pharmaceutical.md
```

---

## Documentation

### For Users

- **[Quick Start Guide](examples/README.md)** - Get started in 5 minutes
- **[Example Documentation](examples/)** - Detailed guides for each example
- **[FHEVM Concepts](FHEVM_CONCEPTS.md)** - Deep dive into FHE patterns

### For Developers

- **[Developer Guide](DEVELOPER_GUIDE.md)** - How to add new examples
- **[Testing Guidelines](DEVELOPER_GUIDE.md#testing-guidelines)** - Write effective tests
- **[Documentation Standards](DEVELOPER_GUIDE.md#documentation-standards)** - Documentation best practices

### External Resources

- [FHEVM Documentation](https://docs.zama.ai/fhevm) - Official FHEVM docs
- [FHEVM Examples](https://docs.zama.org/protocol/examples) - Protocol examples
- [Hardhat Documentation](https://hardhat.org/docs) - Hardhat framework

---

## Competition Submission

### Zama Bounty Track - December 2025

This project is submitted for the **Zama FHEVM Example Hub Bounty**.

#### Deliverables Checklist

- ✅ **Base Template**: Complete Hardhat template with FHEVM
- ✅ **Automation Scripts**: TypeScript CLI tools for generation
- ✅ **Example Repositories**: Multiple working examples
- ✅ **Documentation**: Auto-generated GitBook-compatible docs
- ✅ **Developer Guide**: Complete guide for adding examples
- ✅ **Testing**: Comprehensive test coverage
- ✅ **Demonstration Video**: Setup and usage walkthrough

#### Bonus Points

- 🌟 **Creative Example**: Privacy Pharmaceutical Procurement
- 🌟 **Advanced Patterns**: Encrypted reputation, private matching
- 🌟 **Clean Automation**: Elegant TypeScript automation scripts
- 🌟 **Comprehensive Documentation**: 500+ lines of detailed guides
- 🌟 **Testing Coverage**: Full lifecycle with edge cases
- 🌟 **Error Handling**: Anti-pattern demonstrations

[→ View Full Submission Details](COMPETITION_SUBMISSION.md)

---

## Key Features Showcase

### Privacy Pharmaceutical Procurement

The flagship example demonstrating real-world FHEVM usage:

```solidity
// Buyer creates encrypted order
function createOrder(uint32 drugId, uint32 quantity, uint64 maxBudget) external {
    euint32 encryptedDrugId = FHE.asEuint32(drugId);
    euint32 encryptedQuantity = FHE.asEuint32(quantity);
    euint64 encryptedBudget = FHE.asEuint64(maxBudget);
    // ... store with permissions
}

// Supplier submits encrypted bid
function submitBid(uint32 orderId, uint64 price, uint32 available) external {
    euint64 encryptedPrice = FHE.asEuint64(price);
    euint32 encryptedQuantity = FHE.asEuint32(available);
    // ... store with permissions
}

// Contract matches order using FHE operations
function matchOrder(uint32 orderId) external {
    // ALL comparisons happen on encrypted data
    ebool canFulfill = FHE.ge(bid.quantity, order.quantity);
    ebool withinBudget = FHE.le(bid.price, order.budget);
    ebool isBestPrice = FHE.lt(bid.price, bestPrice);
    // ... select best supplier privately
}
```

**Result**: Complete sealed-bid auction on encrypted data. No party (including the contract) sees actual values until the winner is selected.

---

## Testing

### Run All Tests

```bash
# Test base template
cd fhevm-hardhat-template
npm install
npm run test

# Test specific example
cd contracts/basic
npx hardhat test test/basic/FHECounter.test.ts
```

### Test Generated Examples

```bash
# Generate and test an example
ts-node scripts/create-fhevm-example.ts fhe-counter ./test-output/fhe-counter
cd ./test-output/fhe-counter
npm install && npm test
```

---

## Deployment

### Deploy to Sepolia

```bash
# Set up environment
npx hardhat vars set MNEMONIC
npx hardhat vars set INFURA_API_KEY
npx hardhat vars set ETHERSCAN_API_KEY

# Deploy
npx hardhat deploy --network sepolia

# Verify
npx hardhat verify --network sepolia <CONTRACT_ADDRESS>
```

---

## License

This project is licensed under the **BSD-3-Clause-Clear License**.

See [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- **Zama** for FHEVM technology and bounty program
- **OpenZeppelin** for confidential contract patterns
- **Hardhat** for the excellent development framework

---

## Contact & Support

- **Issues**: Open an issue on GitHub
- **Zama Discord**: https://discord.com/invite/zama
- **Zama Forum**: https://community.zama.ai
- **Documentation**: https://docs.zama.ai/fhevm

---

**Built with ❤️ using [FHEVM](https://github.com/zama-ai/fhevm) by Zama**

**Submitted for: Zama Bounty Track - December 2025**
