# FHEVM Examples Documentation

Welcome to the FHEVM Examples Hub documentation! This comprehensive guide provides detailed information about building privacy-preserving smart contracts using Fully Homomorphic Encryption.

## Overview

This documentation covers:

- **Basic Examples**: Fundamental FHEVM concepts and patterns
- **Advanced Examples**: Real-world applications and complex use cases
- **Best Practices**: Recommended patterns and anti-patterns to avoid
- **Testing Strategies**: How to test encrypted smart contracts
- **Deployment Guides**: Step-by-step deployment instructions

## What is FHEVM?

FHEVM (Fully Homomorphic Encryption Virtual Machine) enables smart contracts to perform computations on encrypted data without decrypting it. This revolutionary technology allows:

- 🔐 **Private Data**: Keep sensitive information encrypted on-chain
- 🧮 **Encrypted Computations**: Perform operations on encrypted values
- 🎯 **Selective Decryption**: Reveal data only to authorized parties
- ✅ **Verifiable Results**: Maintain blockchain's trustless guarantees

## Getting Started

### Quick Start

1. **Generate an example:**
   ```bash
   ts-node scripts/create-fhevm-example.ts fhe-counter ./my-project
   ```

2. **Install dependencies:**
   ```bash
   cd my-project
   npm install
   ```

3. **Run tests:**
   ```bash
   npm run test
   ```

### Example Categories

#### Basic Examples

Perfect for learning FHEVM fundamentals:

- **FHE Counter**: Simple encrypted counter
- **Encrypt Single Value**: Basic encryption patterns
- **Encrypt Multiple Values**: Batch encryption
- **User Decryption**: Decrypting values for users
- **Public Decryption**: Async decryption workflows

#### Advanced Examples

Real-world applications:

- **Privacy Pharmaceutical Procurement**: Complete supply chain with encrypted bids and private matching

## Core FHEVM Concepts

### 1. Encrypted Data Types

FHEVM provides encrypted versions of standard Solidity types:

```solidity
euint8   // Encrypted 8-bit unsigned integer
euint16  // Encrypted 16-bit unsigned integer
euint32  // Encrypted 32-bit unsigned integer
euint64  // Encrypted 64-bit unsigned integer
ebool    // Encrypted boolean
```

### 2. FHE Operations

Perform computations on encrypted data:

```solidity
// Arithmetic
FHE.add(a, b)    // Encrypted addition
FHE.sub(a, b)    // Encrypted subtraction
FHE.mul(a, b)    // Encrypted multiplication

// Comparison
FHE.eq(a, b)     // Encrypted equality
FHE.ne(a, b)     // Encrypted inequality
FHE.lt(a, b)     // Encrypted less than
FHE.le(a, b)     // Encrypted less than or equal
FHE.gt(a, b)     // Encrypted greater than
FHE.ge(a, b)     // Encrypted greater than or equal

// Logic
FHE.and(a, b)    // Encrypted AND
FHE.or(a, b)     // Encrypted OR
FHE.not(a)       // Encrypted NOT
FHE.select(condition, ifTrue, ifFalse)  // Encrypted conditional
```

### 3. Access Control

Manage who can decrypt encrypted values:

```solidity
// Grant contract permission to use encrypted value
FHE.allowThis(encryptedValue);

// Grant user permission to decrypt value
FHE.allow(encryptedValue, userAddress);

// Grant transient permission (gas-efficient, temporary)
FHE.allowTransient(encryptedValue, userAddress);
```

### 4. Input Proofs

Validate that users know the plaintext of encrypted inputs:

```solidity
// Convert external encrypted input with proof
euint32 value = FHE.fromExternal(externalInput, inputProof);

// Internal encryption (no proof needed)
euint32 value = FHE.asEuint32(plaintextValue);
```

### 5. Decryption

Reveal encrypted values when needed:

```solidity
// Request async decryption
bytes32[] memory cts = new bytes32[](2);
cts[0] = FHE.toBytes32(encryptedValue1);
cts[1] = FHE.toBytes32(encryptedValue2);

FHE.requestDecryption(cts, this.callback.selector);

// Callback receives decrypted values
function callback(
    uint256 requestId,
    uint32 decryptedValue1,
    uint32 decryptedValue2,
    bytes[] memory signatures
) external {
    // Process decrypted values
}
```

## Best Practices

### ✅ DO: Grant Proper Permissions

```solidity
euint32 value = FHE.asEuint32(42);

// ALWAYS grant contract permission first
FHE.allowThis(value);

// Then grant user permission if needed
FHE.allow(value, msg.sender);
```

### ✅ DO: Use Input Proofs for External Inputs

```solidity
function storeValue(externalEuint32 input, bytes calldata proof) external {
    // Convert with proof validation
    euint32 value = FHE.fromExternal(input, proof);
    // ...
}
```

### ✅ DO: Handle Encrypted Comparisons Correctly

```solidity
// Compare encrypted values
ebool isGreater = FHE.gt(encryptedA, encryptedB);

// Use in conditional logic
euint32 result = FHE.select(isGreater, valueIfTrue, valueIfFalse);
```

### ❌ DON'T: Forget allowThis Permission

```solidity
// WRONG: Missing FHE.allowThis
euint32 value = FHE.asEuint32(42);
FHE.allow(value, msg.sender);  // Contract can't use this value!

// CORRECT: Grant contract permission first
FHE.allowThis(value);
FHE.allow(value, msg.sender);
```

### ❌ DON'T: Use View Functions with Encrypted Returns

```solidity
// WRONG: Cannot decrypt in view function
function getValue() external view returns (uint32) {
    return FHE.decrypt(encryptedValue);  // Not allowed!
}

// CORRECT: Return encrypted handle
function getValue() external view returns (euint32) {
    return encryptedValue;  // User decrypts client-side
}
```

### ❌ DON'T: Mix Encrypted and Plaintext Incorrectly

```solidity
// WRONG: Cannot add encrypted and plaintext directly
euint32 result = encryptedValue + 5;  // Compile error!

// CORRECT: Convert plaintext to encrypted first
euint32 result = FHE.add(encryptedValue, FHE.asEuint32(5));
```

## Common Patterns

### Pattern 1: Encrypted Storage

```solidity
mapping(address => euint32) private userBalances;

function setBalance(externalEuint32 input, bytes calldata proof) external {
    euint32 balance = FHE.fromExternal(input, proof);
    userBalances[msg.sender] = balance;

    FHE.allowThis(balance);
    FHE.allow(balance, msg.sender);
}
```

### Pattern 2: Encrypted Comparison

```solidity
function compareValues(uint32 orderId) external {
    ebool condition = FHE.le(bid.price, order.budget);

    // Use condition in encrypted logic
    euint32 result = FHE.select(condition, approvedValue, rejectedValue);
}
```

### Pattern 3: Batch Decryption

```solidity
function revealMultiple() external {
    bytes32[] memory cts = new bytes32[](3);
    cts[0] = FHE.toBytes32(value1);
    cts[1] = FHE.toBytes32(value2);
    cts[2] = FHE.toBytes32(value3);

    FHE.requestDecryption(cts, this.processResults.selector);
}

function processResults(
    uint256 requestId,
    uint32 v1,
    uint32 v2,
    uint32 v3,
    bytes[] memory signatures
) external {
    // Process decrypted values
}
```

## Testing Encrypted Contracts

### Basic Test Structure

```typescript
import { expect } from "chai";
import { ethers } from "hardhat";

describe("MyContract", function () {
  let contract: any;

  beforeEach(async function () {
    const Contract = await ethers.getContractFactory("MyContract");
    contract = await Contract.deploy();
    await contract.waitForDeployment();
  });

  it("Should handle encrypted operations", async function () {
    // Test implementation
  });
});
```

## Resources

- [FHEVM Official Documentation](https://docs.zama.ai/fhevm)
- [FHEVM GitHub Repository](https://github.com/zama-ai/fhevm)
- [Zama Community Forum](https://community.zama.ai)
- [Zama Discord](https://discord.com/invite/zama)

## Next Steps

1. Browse the [example list](SUMMARY.md)
2. Generate an example: `ts-node scripts/create-fhevm-example.ts <example-name>`
3. Read the [Developer Guide](../DEVELOPER_GUIDE.md)
4. Join the [Zama Community](https://community.zama.ai)

---

**Ready to build privacy-preserving smart contracts? Let's get started!**
