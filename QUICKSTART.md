# Quick Start Guide - FHEVM Examples Hub

Get started with FHEVM Examples Hub in 5 minutes!

## Prerequisites

- Node.js 20+
- npm 7+
- Git

## Installation

```bash
# Navigate to project directory
cd D:\\\PrivacyPharma

# Install root dependencies (for automation tools)
npm install
```

## Generate Your First Example

### Option 1: Single Example (Recommended for Learning)

```bash
# Generate the FHE Counter example
npm run create:example fhe-counter ./output/my-first-example

# Navigate to generated project
cd output/my-first-example

# Install dependencies
npm install

# Compile contracts
npm run compile

# Run tests
npm run test
```

### Option 2: Category Project (Multiple Examples)

```bash
# Generate all basic examples together
ts-node scripts/create-fhevm-category.ts basic ./output/basic-examples

# Navigate to generated project
cd output/basic-examples

# Install, compile, and test
npm install && npm run compile && npm run test
```

## Available Examples

Run this command to see all available examples:

```bash
ts-node scripts/create-fhevm-example.ts --help
```

### Basic Examples

- `fhe-counter` - Simple encrypted counter
- `encrypt-single-value` - Single value encryption
- `encrypt-multiple-values` - Batch encryption
- `user-decrypt-single` - User decryption
- `public-decrypt-single` - Public decryption
- `fhe-arithmetic` - Arithmetic operations (add, sub, mul)
- `fhe-comparison` - Comparison operations (eq, lt, gt, etc.)
- `access-control` - Access control patterns
- `input-proofs` - Input proof explanation
- `handles` - Understanding handles

### Advanced Examples

- `privacy-pharmaceutical` - Complete pharmaceutical procurement system

## Available Categories

Run this command to see all categories:

```bash
ts-node scripts/create-fhevm-category.ts --help
```

Categories:
- `basic` - Core FHEVM examples
- `encryption` - Encryption patterns
- `decryption` - Decryption patterns
- `operations` - FHE operations
- `concepts` - FHEVM concepts
- `advanced` - Real-world applications

## Generate Documentation

```bash
# Generate docs for a single example
npm run generate:docs fhe-counter

# Generate docs for all examples
npm run generate:all-docs

# View generated documentation
cat examples/fhe-counter.md
```

## Project Structure

```
PrivacyPharma/
├── fhevm-hardhat-template/    # Base template
├── contracts/                 # Example contracts
│   ├── basic/                 # Basic examples
│   └── advanced/              # Advanced examples
├── test/                      # Test files
├── scripts/                   # Automation tools
│   ├── create-fhevm-example.ts      # Generate single example
│   ├── create-fhevm-category.ts     # Generate category project
│   └── generate-docs.ts             # Generate documentation
├── examples/                  # Generated documentation
├── PROJECT_README.md          # Full documentation
└── DEVELOPER_GUIDE.md         # Contributor guide
```

## Next Steps

### For Learners

1. Start with `fhe-counter` example
2. Try `encrypt-single-value` to understand encryption
3. Learn about `access-control` patterns
4. Explore `fhe-arithmetic` operations
5. Study the advanced `privacy-pharmaceutical` example

### For Developers

1. Read [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)
2. Explore existing contracts in `contracts/`
3. Study tests in `test/`
4. Add your own examples following the guide

### For Contributors

1. Fork the repository
2. Create new examples following patterns in `contracts/basic/`
3. Write comprehensive tests
4. Update automation scripts
5. Submit pull request

## Common Commands

```bash
# Generate example
npm run create:example <example-name> <output-dir>

# Generate category
ts-node scripts/create-fhevm-category.ts <category> <output-dir>

# Generate docs
npm run generate:docs <example-name>
npm run generate:all-docs

# Test base template
cd fhevm-hardhat-template && npm install && npm test
```

## Example: Complete Workflow

```bash
# 1. Generate FHE Counter example
npm run create:example fhe-counter ./my-counter

# 2. Navigate to project
cd my-counter

# 3. Install dependencies
npm install

# 4. Compile contracts
npm run compile

# 5. Run tests
npm run test

# 6. Deploy to local network (optional)
npx hardhat node  # In one terminal
npx hardhat deploy --network localhost  # In another terminal

# 7. Deploy to Sepolia (optional)
npx hardhat vars set MNEMONIC
npx hardhat vars set INFURA_API_KEY
npx hardhat deploy --network sepolia
```

## Troubleshooting

### Issue: TypeScript errors in automation scripts

**Solution:**
```bash
npm install
```

### Issue: Contract compilation fails

**Solution:**
```bash
cd output/your-example
npm install
npm run compile
```

### Issue: Tests fail

**Solution:**
Check that all dependencies are installed and contracts are compiled.

## Resources

- **Full Documentation**: [PROJECT_README.md](PROJECT_README.md)
- **Developer Guide**: [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)
- **Submission Details**: [SUBMISSION_OVERVIEW.md](SUBMISSION_OVERVIEW.md)
- **FHEVM Concepts**: [FHEVM_CONCEPTS.md](FHEVM_CONCEPTS.md)
- **Examples Documentation**: [examples/README.md](examples/README.md)

## Support

- **FHEVM Documentation**: https://docs.zama.ai/fhevm
- **Zama Discord**: https://discord.com/invite/zama
- **Zama Forum**: https://community.zama.ai

---

**Ready to build privacy-preserving smart contracts? Start now!**

```bash
npm run create:example fhe-counter ./my-first-fhevm-project
```
