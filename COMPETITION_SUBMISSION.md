# Zama Bounty Track December 2025 - Submission

## Project: PrivacyPharma

**Anonymous Pharmaceutical Procurement using FHEVM**

---

## Project Overview

PrivacyPharma demonstrates a complete FHEVM implementation for anonymous pharmaceutical procurement. The system allows buyers to create encrypted orders, suppliers to submit encrypted bids, and uses private computation to match orders with the best supplier—all without revealing sensitive information until fulfillment.

### Key Innovation

This project showcases how FHE enables **real privacy in decentralized systems** by performing supplier matching entirely on encrypted data. Traditional smart contracts would require revealing bid prices to compare them, but PrivacyPharma proves computations on encrypted values are practical and efficient.

---

## Bounty Requirements Checklist

### ✅ Project Structure and Simplicity
- [x] Uses Hardhat as the development framework
- [x] Independent, standalone repository structure
- [x] Clean organization: `contracts/`, `test/`, `scripts/`, `public/`
- [x] Single example focused on pharmaceutical procurement
- [x] All dependencies clearly listed in `package.json`

### ✅ Scaffolding/Automation
- [x] **Setup Script** (`scripts/setup.sh`) - Automated environment setup
- [x] **Deployment Script** (`scripts/deploy.js`) - One-command deployment to Sepolia
- [x] **Verification Script** (`scripts/verify-supplier.js`) - Supplier management
- [x] **Documentation Generator** (`scripts/generate-docs.js`) - Auto-generates docs from code annotations

### ✅ Example Type: Advanced FHEVM Use Case
Demonstrates multiple FHEVM concepts:
- **Encrypted data types** (euint32, euint64, ebool)
- **Access control** (FHE.allow, FHE.allowThis)
- **Private computations** (FHE.ge, FHE.le, FHE.lt, FHE.and, FHE.select)
- **Async decryption** workflow with callbacks
- **Real-world application** - pharmaceutical supply chain privacy

### ✅ Documentation Strategy
- [x] **README.md** - Comprehensive guide with FHEVM concepts
- [x] **FHEVM_CONCEPTS.md** - Deep dive into FHE patterns used
- [x] **Inline comments** - TSDoc/JSDoc style in tests
- [x] **Chapter tags** - access-control, encryption, private-computation, public-decryption
- [x] **Auto-generated docs** - Script extracts annotations to create documentation

### ✅ Comprehensive Tests
- [x] **Full test suite** (`test/PrivacyPharma.test.js`) with 20+ test cases
- [x] **Deployment tests** - Contract initialization
- [x] **Access control tests** - Owner-only, supplier-only patterns
- [x] **Encryption tests** - Creating orders with encrypted data
- [x] **Computation tests** - Private supplier matching
- [x] **Anti-pattern tests** - Common mistakes to avoid
- [x] **Integration tests** - Complete order lifecycle
- [x] All tests documented with FHEVM concepts

---

## FHEVM Concepts Demonstrated

### 1. Encrypted Data Types (`chapter: encryption`)

```solidity
euint32 encryptedDrugId = FHE.asEuint32(_drugId);
euint32 encryptedQuantity = FHE.asEuint32(_quantity);
euint64 encryptedBudget = FHE.asEuint64(_maxBudget);
```

**Why:** Drug IDs, quantities, and budgets must remain private throughout the procurement process.

### 2. Access Control (`chapter: access-control`)

```solidity
FHE.allowThis(encryptedDrugId);         // Contract can use encrypted value
FHE.allow(encryptedDrugId, msg.sender); // Buyer can decrypt
FHE.allow(encryptedPrice, orders[orderId].buyer); // Share with buyer
```

**Why:** Fine-grained control over who can decrypt which encrypted values.

### 3. Private Computations (`chapter: private-computation`)

```solidity
ebool canFulfill = FHE.ge(bid.encryptedAvailableQuantity, order.encryptedQuantity);
ebool withinBudget = FHE.le(bid.encryptedPrice, order.encryptedBudget);
ebool isQualified = FHE.and(canFulfill, withinBudget);
bestPrice = FHE.select(shouldSelect, bid.encryptedPrice, bestPrice);
```

**Why:** Match suppliers without revealing individual bids—core value proposition of FHE.

### 4. Async Decryption (`chapter: public-decryption`)

```solidity
FHE.requestDecryption(cts, this.processFulfillment.selector);

function processFulfillment(uint256 requestId, uint32 drugId, ...) {
    // Process decrypted values
}
```

**Why:** Reveals order details only when supplier fulfills the order.

---

## Demonstration Video

**Video showcasing:**
1. Project setup and compilation
2. Running comprehensive test suite
3. Deploying to Sepolia testnet
4. Creating encrypted orders via frontend
5. Suppliers submitting encrypted bids
6. Private supplier matching
7. Order fulfillment with decryption
8. Code walkthrough explaining FHEVM concepts

---

## Project Structure

```
privacy-pharma/
├── contracts/
│   └── PrivacyPharma.sol          # Main FHEVM smart contract
├── test/
│   └── PrivacyPharma.test.js      # 20+ comprehensive tests with annotations
├── scripts/
│   ├── deploy.js                   # Automated deployment
│   ├── verify-supplier.js          # Supplier verification utility
│   ├── generate-docs.js            # Auto-documentation generator
│   └── setup.sh                    # Complete project setup script
├── public/
│   └── index.html                  # Frontend application
├── docs/                            # Auto-generated documentation
├── README.md                        # Main documentation
├── FHEVM_CONCEPTS.md               # FHEVM deep dive
├── DEPLOYMENT.md                   # Deployment guide
├── LICENSE                          # MIT License
├── hardhat.config.js               # Hardhat configuration
└── package.json                    # Dependencies and scripts
```

---

## Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Compile contract
npm run compile

# 3. Run tests
npm test

# 4. Deploy to Sepolia
npx hardhat run scripts/deploy.js --network sepolia

# 5. Run frontend locally
npm start
```

---

## Bonus Features

### ✅ Creative Example
- Real-world pharmaceutical supply chain use case
- Demonstrates practical privacy benefits
- Goes beyond basic FHE operations

### ✅ Advanced Patterns
- Multi-supplier encrypted auction
- Conditional decryption (only winner sees details)
- Reputation system with encrypted scores
- Role-based access control

### ✅ Clean Automation
- One-command setup script
- Automated deployment with verification
- Auto-documentation from code annotations
- GitBook-compatible documentation structure

### ✅ Comprehensive Documentation
- Main README with quick start
- Deep dive FHEVM concepts guide
- Inline code documentation with chapter tags
- Auto-generated test documentation

### ✅ Test Coverage
- 20+ test cases covering all functions
- Edge case testing
- Anti-pattern demonstrations
- Full lifecycle integration tests

### ✅ Error Handling
- Common pitfall examples in tests
- Clear error messages
- Input validation patterns
- Access control demonstrations

### ✅ Category Organization
Organized by chapters:
- `encryption` - Encrypted data handling
- `access-control` - Permission management
- `private-computation` - FHE operations
- `public-decryption` - Revealing values
- `anti-patterns` - What not to do

---

## Technical Highlights

### 1. Encrypted Supplier Matching Algorithm

The contract performs a complete supplier selection **entirely on encrypted data**:

```solidity
function _findBestSupplier(uint32 orderId) private returns (address) {
    // All comparisons on encrypted values
    ebool canFulfill = FHE.ge(bid.encryptedAvailableQuantity, order.encryptedQuantity);
    ebool withinBudget = FHE.le(bid.encryptedPrice, order.encryptedBudget);
    ebool isBestPrice = FHE.lt(bid.encryptedPrice, bestPrice);

    // Combine conditions in encrypted domain
    ebool isQualified = FHE.and(canFulfill, withinBudget);
    ebool shouldSelect = FHE.and(isQualified, isBestPrice);

    // Update best price conditionally (still encrypted)
    bestPrice = FHE.select(shouldSelect, bid.encryptedPrice, bestPrice);

    return currentBest;
}
```

**Impact:** No party (including the contract) ever sees actual bid prices during comparison.

### 2. Granular Access Control

Different parties have access to different encrypted values:

- **Buyers:** Can decrypt their own order details
- **Suppliers:** Can decrypt their own bids
- **Contract:** Can perform computations but not decrypt
- **Selected Supplier:** Gains access to full order details upon selection

### 3. Async Decryption Workflow

Demonstrates proper FHE decryption pattern:
1. Supplier initiates fulfillment
2. Contract requests decryption from FHE network
3. FHE network decrypts off-chain
4. Callback provides decrypted values + proof
5. Contract verifies proof and processes

---

## Why This Example Stands Out

1. **Real-World Relevance:** Pharmaceutical procurement has genuine privacy needs
2. **Complete Implementation:** End-to-end from encryption to decryption
3. **Educational Value:** Clear documentation of every FHEVM concept used
4. **Production-Ready Patterns:** Access control, validation, error handling
5. **Extensive Testing:** Every function tested with edge cases
6. **Developer Experience:** Automated setup, deployment, and documentation

---

## Future Extensions

This example can be extended to demonstrate:
- **Time-based auctions** with encrypted deadlines
- **Multi-round bidding** with encrypted negotiations
- **Reputation decay** using encrypted time factors
- **Batch processing** of multiple orders
- **Cross-chain encrypted messaging** for private communication

---

## Team & Contact

**Project:** PrivacyPharma
**Team:** PrivacyPharma Team
**Built for:** Zama Bounty Track December 2025
**License:** MIT

---

## Resources

- **Live Demo:** [Deploy to Vercel]
- **Documentation:** See README.md and FHEVM_CONCEPTS.md
- **Tests:** Run `npm test` to see all FHEVM concepts in action
- **Zama Docs:** https://docs.zama.ai/fhevm

---

**Thank you for considering PrivacyPharma for the Zama Bounty Track December 2025!**

This project demonstrates practical FHEVM usage in a real-world scenario, comprehensive documentation for developers learning FHE, and production-ready patterns for building privacy-preserving decentralized applications.
