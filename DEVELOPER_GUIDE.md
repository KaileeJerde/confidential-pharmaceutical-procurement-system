# Developer Guide - FHEVM Examples Hub

This guide explains how to add new examples, maintain existing ones, and use the automation tools.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Creating New Examples](#creating-new-examples)
- [Using Automation Tools](#using-automation-tools)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Standards](#documentation-standards)
- [Maintenance and Updates](#maintenance-and-updates)

---

## Overview

This project provides a comprehensive collection of FHEVM examples organized into:

- **Basic Examples**: Fundamental FHEVM concepts (encryption, decryption, operations)
- **Advanced Examples**: Real-world applications (pharmaceutical procurement, auctions, etc.)
- **Base Template**: Reusable Hardhat template for all examples
- **Automation Scripts**: Tools for generating standalone repositories and documentation

---

## Project Structure

```
PrivacyPharma/
├── fhevm-hardhat-template/      # Base Hardhat template
│   ├── contracts/               # Template contract (FHECounter)
│   ├── test/                    # Template tests
│   ├── deploy/                  # Deployment scripts
│   ├── hardhat.config.ts        # Hardhat configuration
│   └── package.json             # Dependencies
│
├── contracts/                   # All example contracts (source)
│   ├── basic/                   # Basic FHE operations
│   │   ├── FHECounter.sol
│   │   ├── encrypt/             # Encryption examples
│   │   ├── decrypt/             # Decryption examples
│   │   └── operations/          # FHE operators (add, sub, etc.)
│   └── advanced/                # Advanced examples
│       └── PrivacyPharma.sol    # Pharmaceutical procurement example
│
├── test/                        # All test files (mirrors contracts/)
│   ├── basic/
│   └── advanced/
│
├── examples/                    # Generated GitBook documentation
│   ├── SUMMARY.md               # Documentation index
│   └── *.md                     # Individual example docs
│
├── scripts/                     # Automation tools
│   ├── create-fhevm-example.ts  # Repository generator
│   ├── generate-docs.ts         # Documentation generator
│   └── deploy.js                # Legacy deployment script
│
└── README.md                    # Main documentation
```

---

## Creating New Examples

### Step 1: Create the Contract

1. Choose the appropriate directory:
   - Basic examples: `contracts/basic/`
   - Advanced examples: `contracts/advanced/`

2. Create your Solidity contract with proper annotations:

```solidity
// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Your Contract Title
/// @notice Brief description of what this contract does
/// @dev Technical details and important notes
/// @custom:category basic or advanced
/// @custom:chapter encryption, access-control, etc.
contract YourContract is ZamaEthereumConfig {
    // Your implementation
}
```

### Step 2: Create Tests

Create a test file in the corresponding test directory:

```typescript
import { expect } from "chai";
import { ethers } from "hardhat";

/**
 * Test Suite: Your Contract Name
 * @category basic or advanced
 * @chapter encryption, access-control, etc.
 *
 * This test suite demonstrates:
 * - Key concept 1
 * - Key concept 2
 * - Key concept 3
 */
describe("YourContract", function () {
  // Your tests
});
```

### Step 3: Register in Automation Scripts

Add your example to `scripts/create-fhevm-example.ts`:

```typescript
const EXAMPLES_MAP: Record<string, ExampleConfig> = {
  'your-example-name': {
    contract: 'contracts/basic/YourContract.sol',
    test: 'test/basic/YourContract.test.ts',
    description: 'Brief description of your example',
  },
  // ... other examples
};
```

Add to `scripts/generate-docs.ts`:

```typescript
const EXAMPLES_CONFIG: Record<string, DocsConfig> = {
  'your-example-name': {
    title: 'Your Example Title',
    description: 'Detailed description',
    contract: 'contracts/basic/YourContract.sol',
    test: 'test/basic/YourContract.test.ts',
    category: 'Basic',
  },
  // ... other examples
};
```

### Step 4: Test in Base Template

```bash
cd fhevm-hardhat-template/

# Copy your contract and test
cp ../contracts/basic/YourContract.sol contracts/
cp ../test/basic/YourContract.test.ts test/

# Test
npm run compile
npm run test
npm run lint
```

### Step 5: Generate Documentation

```bash
ts-node scripts/generate-docs.ts your-example-name
```

---

## Using Automation Tools

### create-fhevm-example.ts

Generates complete standalone repositories for single examples.

**Usage:**
```bash
ts-node scripts/create-fhevm-example.ts <example-name> [output-dir]
```

**Example:**
```bash
ts-node scripts/create-fhevm-example.ts fhe-counter ./output/my-fhe-counter
cd ./output/my-fhe-counter
npm install
npm run compile
npm run test
```

**What it does:**
1. Clones the base Hardhat template
2. Copies the specified contract and test files
3. Updates configuration files (package.json, deploy scripts)
4. Generates a custom README
5. Creates a ready-to-use standalone repository

### generate-docs.ts

Creates GitBook-formatted documentation from contracts and tests.

**Usage:**
```bash
# Single example
ts-node scripts/generate-docs.ts <example-name>

# All examples
ts-node scripts/generate-docs.ts --all
```

**Example:**
```bash
ts-node scripts/generate-docs.ts fhe-counter
```

**What it does:**
1. Extracts contract and test code
2. Generates formatted markdown
3. Updates SUMMARY.md index
4. Organizes by category (Basic/Advanced)

---

## Testing Guidelines

### Test Structure

```typescript
describe("YourContract", function () {
  let contract: any;
  let owner: any;
  let user1: any;

  beforeEach(async function () {
    // Deploy contract
    const Contract = await ethers.getContractFactory("YourContract");
    contract = await Contract.deploy();
    await contract.waitForDeployment();

    [owner, user1] = await ethers.getSigners();
  });

  describe("Feature Group", function () {
    it("Should test specific behavior", async function () {
      // Test implementation
    });

    it("✅ CORRECT: Demonstrates correct pattern", async function () {
      // Show the right way
    });

    it("❌ ANTI-PATTERN: Demonstrates what not to do", async function () {
      // Show the wrong way (if applicable)
    });
  });
});
```

### Best Practices

1. **Use clear, descriptive test names**
   - Good: "Should allow users to store encrypted values with proper permissions"
   - Bad: "test1"

2. **Include both positive and negative tests**
   - Test expected behavior
   - Test error conditions
   - Test edge cases

3. **Document FHEVM concepts**
   - Add comments explaining FHE operations
   - Mark correct patterns with ✅
   - Mark anti-patterns with ❌

4. **Use proper test organization**
   - Group related tests with `describe`
   - Use `beforeEach` for setup
   - Keep tests independent

---

## Documentation Standards

### Contract Documentation

Use NatSpec comments:

```solidity
/// @title Short title
/// @notice User-friendly description
/// @dev Technical details for developers
/// @param paramName Description of parameter
/// @return Description of return value
/// @custom:category basic or advanced
/// @custom:chapter Chapter tags for documentation
```

### Test Documentation

Use TSDoc/JSDoc style:

```typescript
/**
 * Test Suite: Example Name
 * @category basic or advanced
 * @chapter encryption, access-control, etc.
 *
 * This test suite demonstrates:
 * - Key learning point 1
 * - Key learning point 2
 * - Key learning point 3
 */
```

### Markdown Documentation

Follow this structure:

```markdown
# Title

## Overview
Brief description

## Key Concepts
- Concept 1
- Concept 2

## Code Examples
\`\`\`solidity
// Example code
\`\`\`

## Running the Example
Step-by-step instructions

## Documentation Links
- Related resources
```

---

## Maintenance and Updates

### Updating FHEVM Dependencies

When `@fhevm/solidity` releases a new version:

1. **Update Base Template**
   ```bash
   cd fhevm-hardhat-template/
   npm install @fhevm/solidity@latest
   npm run compile
   npm run test
   ```

2. **Test All Examples**
   ```bash
   # Generate and test a few key examples
   ts-node scripts/create-fhevm-example.ts fhe-counter ./test-output/fhe-counter
   cd ./test-output/fhe-counter
   npm install
   npm test
   ```

3. **Update Documentation**
   If APIs changed, regenerate docs:
   ```bash
   ts-node scripts/generate-docs.ts --all
   ```

### Bulk Operations

```bash
# Regenerate all documentation
ts-node scripts/generate-docs.ts --all

# Test multiple examples
for example in fhe-counter encrypt-single-value privacy-pharmaceutical; do
  ts-node scripts/create-fhevm-example.ts $example ./test-output/$example
  cd ./test-output/$example && npm install && npm test && cd ../..
done
```

### Quality Checklist

Before committing new examples:

- [ ] Contract compiles without errors
- [ ] All tests pass
- [ ] Code follows linting rules (`npm run lint`)
- [ ] Documentation is complete and accurate
- [ ] Automation scripts updated
- [ ] Standalone repository tested
- [ ] Documentation generated successfully

---

## Contributing

When adding examples:

1. Follow existing patterns and structure
2. Include comprehensive comments in code
3. Demonstrate both correct and incorrect usage
4. Update both automation scripts
5. Test generated standalone repository
6. Verify documentation renders correctly

---

## Resources

- [FHEVM Documentation](https://docs.zama.ai/fhevm)
- [FHEVM GitHub](https://github.com/zama-ai/fhevm)
- [Solidity FHE Library](https://docs.zama.ai/fhevm/fundamentals/contract_library)
- [Hardhat Documentation](https://hardhat.org/docs)

---

**Questions?** Check the existing examples in `contracts/` and their tests in `test/` for reference implementations.
