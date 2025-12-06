# FHEVM Concepts in PrivacyPharma

This document explains the FHEVM (Fully Homomorphic Encryption Virtual Machine) concepts demonstrated in the PrivacyPharma contract.

## Table of Contents

1. [Overview](#overview)
2. [Encrypted Data Types](#encrypted-data-types)
3. [Access Control Patterns](#access-control-patterns)
4. [Private Computations](#private-computations)
5. [Decryption Workflow](#decryption-workflow)
6. [Common Pitfalls](#common-pitfalls)
7. [Real-World Applications](#real-world-applications)

## Overview

Fully Homomorphic Encryption (FHE) allows computation on encrypted data without decryption. In PrivacyPharma:

- **Data stays encrypted** from creation until fulfillment
- **Comparisons happen on encrypted values** - contract never sees actual amounts
- **Smart matching logic** works entirely in the encrypted domain
- **Decryption happens selectively** - only authorized parties see results

### Why This Matters

Traditional blockchain contracts can't keep data private because:
- All data must be visible to contract logic
- Consensus requires transparency
- Privacy requires either off-chain computation or trusted third parties

FHE solves this by:
- Allowing encrypted computations
- No decryption needed for contract operations
- Decryption only where/when necessary
- Cryptographic guarantees of privacy

## Encrypted Data Types

### euint32 - 32-bit Encrypted Unsigned Integer

**Use Case:** Small values like drug IDs and quantities

```solidity
// In PrivacyPharma.sol - Drug ID encryption
euint32 encryptedDrugId = FHE.asEuint32(_drugId);

// Can't read the value directly
// uint32 realValue = encryptedDrugId;  // ❌ INVALID

// Only operations on encrypted values allowed
euint32 adjusted = FHE.add(encryptedDrugId, 1);  // ✅ Valid
```

**Storage:**
```solidity
struct PharmaOrder {
    euint32 encryptedDrugId;      // Drug identifier (encrypted)
    euint32 encryptedQuantity;    // Amount needed (encrypted)
    // ... other fields
}

mapping(uint32 => PharmaOrder) public orders;
```

**Operations:**
- `FHE.add(a, b)` - Addition
- `FHE.sub(a, b)` - Subtraction
- `FHE.mul(a, b)` - Multiplication
- `FHE.eq(a, b)` - Equality check (returns ebool)
- `FHE.lt(a, b)` - Less than (returns ebool)
- `FHE.le(a, b)` - Less than or equal (returns ebool)
- `FHE.gt(a, b)` - Greater than (returns ebool)
- `FHE.ge(a, b)` - Greater than or equal (returns ebool)

### euint64 - 64-bit Encrypted Unsigned Integer

**Use Case:** Larger values like prices and budgets

```solidity
// In PrivacyPharma.sol - Budget encryption
euint64 encryptedBudget = FHE.asEuint64(_maxBudget);

// Used for price comparisons
euint64 encryptedPrice = FHE.asEuint64(_price);
ebool withinBudget = FHE.le(encryptedPrice, encryptedBudget);
```

**Why euint64 vs euint32:**
- Budgets can exceed 32-bit limit (4.3 billion)
- uint64 allows values up to 18.4 quintillion
- Trade-off: larger encrypted values = more computation

### ebool - Encrypted Boolean

**Purpose:** Results of encrypted comparisons

```solidity
// Comparison returns encrypted boolean
ebool canFulfill = FHE.ge(bid.encryptedAvailableQuantity, order.encryptedQuantity);
// Value of canFulfill is encrypted - we can't read it
// But we can use it in further encrypted operations

// Combine conditions with logical operations
ebool qualified = FHE.and(canFulfill, withinBudget);  // AND operation
ebool fallback = FHE.or(canFulfill, withinBudget);   // OR operation
```

## Access Control Patterns

### Pattern 1: Owner-Only Functions

```solidity
/**
 * @notice Only contract owner can verify suppliers
 * @dev Demonstrates role-based access control
 * @chapter access-control
 */
modifier onlyOwner() {
    require(msg.sender == owner, "Not authorized");
    _;
}

function verifySupplier(address supplier) external onlyOwner {
    verifiedSuppliers[supplier] = true;
    // Initialize encrypted reputation
    euint32 initialReputation = FHE.asEuint32(100);
    supplierReputation[supplier] = initialReputation;
    FHE.allowThis(initialReputation);
    FHE.allow(initialReputation, supplier);
}
```

### Pattern 2: Role-Based Access (Verified Suppliers)

```solidity
/**
 * @notice Only verified suppliers can submit bids
 * @dev Demonstrates membership-based access control
 * @chapter access-control
 */
modifier onlyVerifiedSupplier() {
    require(verifiedSuppliers[msg.sender], "Not verified supplier");
    _;
}

function submitBid(uint32 orderId, uint64 _price, uint32 _availableQuantity)
    external
    onlyVerifiedSupplier
{
    // Only verified suppliers can reach here
    // ...
}
```

### Pattern 3: Owner-Specific Operations

```solidity
/**
 * @notice Only the order owner (buyer) can match
 * @dev Demonstrates resource owner verification
 * @chapter access-control
 */
modifier onlyActiveBuyer(uint32 orderId) {
    require(orders[orderId].buyer == msg.sender, "Not order owner");
    require(orders[orderId].orderActive, "Order not active");
    _;
}

function matchOrder(uint32 orderId) external onlyActiveBuyer(orderId) {
    // Only order creator can call this
    // ...
}
```

### Pattern 4: Encrypted Access Control with FHE.allow()

```solidity
/**
 * @notice Grant and manage access to encrypted values
 * @dev Core FHEVM access control mechanism
 * @chapter access-control
 */
function createOrder(
    uint32 _drugId,
    uint32 _quantity,
    uint64 _maxBudget
) external {
    // Create encrypted values
    euint32 encryptedDrugId = FHE.asEuint32(_drugId);
    euint32 encryptedQuantity = FHE.asEuint32(_quantity);
    euint64 encryptedBudget = FHE.asEuint64(_maxBudget);

    // ... store in order ...

    // Grant permissions
    FHE.allowThis(encryptedDrugId);              // Contract can use this value
    FHE.allowThis(encryptedQuantity);
    FHE.allowThis(encryptedBudget);

    FHE.allow(encryptedDrugId, msg.sender);      // Buyer can decrypt
    FHE.allow(encryptedQuantity, msg.sender);
    FHE.allow(encryptedBudget, msg.sender);
}
```

**Key Concepts:**
- `FHE.allowThis(encValue)` - Contract can read the encrypted value's type
- `FHE.allow(encValue, address)` - Specific address can decrypt the value
- Without these calls, only the wallet that encrypted it can use it

## Private Computations

### Example 1: Simple Comparison on Encrypted Data

```solidity
/**
 * @notice Check if supplier can fulfill quantity (encrypted)
 * @dev Demonstrates FHE.ge() for "greater than or equal"
 * @chapter private-computation
 */
ebool canFulfill = FHE.ge(
    bid.encryptedAvailableQuantity,  // What supplier has (encrypted)
    order.encryptedQuantity           // What buyer needs (encrypted)
);
```

**What Happens:**
1. Both values remain encrypted
2. FHE.ge() performs comparison on encrypted data
3. Returns encrypted boolean result
4. Contract never knows the actual values
5. Result is encrypted and can be used in further operations

### Example 2: Combining Multiple Conditions

```solidity
/**
 * @notice Select supplier matching all criteria (all encrypted)
 * @dev Demonstrates FHE.and() for combining conditions
 * @chapter private-computation
 */
// Condition 1: Can fulfill quantity?
ebool canFulfill = FHE.ge(
    bid.encryptedAvailableQuantity,
    order.encryptedQuantity
);

// Condition 2: Price within budget?
ebool withinBudget = FHE.le(
    bid.encryptedPrice,
    order.encryptedBudget
);

// Condition 3: Is this the best price?
ebool isBestPrice = FHE.lt(
    bid.encryptedPrice,
    bestPrice
);

// Combine all conditions
ebool isQualified = FHE.and(canFulfill, withinBudget);
ebool shouldSelect = FHE.and(isQualified, isBestPrice);
```

**Why This Matters:**
- No one sees: quantities, prices, or budgets
- Comparison logic is transparent (on-chain, auditable)
- Results are encrypted
- Supplier's pricing strategy stays private

### Example 3: Conditional Update

```solidity
/**
 * @notice Conditionally update best price (encrypted)
 * @dev Demonstrates FHE.select() for conditional logic
 * @chapter private-computation
 */
bestPrice = FHE.select(
    shouldSelect,        // Encrypted condition
    bid.encryptedPrice,  // New value if true
    bestPrice            // Keep old value if false
);
```

**Flow:**
1. `shouldSelect` is encrypted boolean
2. If true: update `bestPrice` with current bid
3. If false: keep existing `bestPrice`
4. All operations on encrypted data
5. No one knows the actual decision

## Decryption Workflow

### Request-Based Decryption

```solidity
/**
 * @notice Request decryption of order details
 * @dev Initiates async decryption workflow
 * @chapter public-decryption
 */
function fulfillOrder(uint32 orderId) external {
    require(orders[orderId].supplier == msg.sender, "Not selected supplier");

    PharmaOrder storage order = orders[orderId];

    // Prepare values to decrypt
    bytes32[] memory cts = new bytes32[](3);
    cts[0] = FHE.toBytes32(order.encryptedDrugId);
    cts[1] = FHE.toBytes32(order.encryptedQuantity);
    cts[2] = FHE.toBytes32(supplierBids[orderId][msg.sender].encryptedPrice);

    // Request async decryption
    FHE.requestDecryption(cts, this.processFulfillment.selector);
}
```

### Decryption Callback

```solidity
/**
 * @notice Process decrypted order details
 * @dev Called by FHE network after decryption
 * @chapter public-decryption
 */
function processFulfillment(
    uint256 requestId,
    uint32 drugId,           // Decrypted value
    uint32 quantity,         // Decrypted value
    uint64 price,            // Decrypted value
    bytes[] memory signatures  // Proof of decryption
) external {
    // Verify signatures
    // (Note: Simplified for demo)

    // Values now revealed and can be used
    uint32 orderId = _findPendingOrder();
    PharmaOrder storage order = orders[orderId];

    order.orderFulfilled = true;
    order.revealedDrugId = drugId;        // Revealed
    order.revealedQuantity = quantity;    // Revealed
    order.revealedPrice = price;          // Revealed
    order.fulfillmentTime = block.timestamp;

    emit OrderFulfilled(orderId, drugId, quantity, price);
}
```

**Key Points:**
- Decryption happens off-chain by FHE network
- Contract receives decrypted values + proof
- Callback verifies proof before using values
- Only authorized parties initiated decryption

## Common Pitfalls

### ❌ WRONG: Reading Encrypted Value Directly

```solidity
// This will NOT work - encrypted values are not readable integers
euint32 secret = FHE.asEuint32(12345);
uint32 revealed = secret;  // ❌ COMPILER ERROR

// Even more wrong - trying to compare
if (secret > 100) { }       // ❌ COMPILER ERROR
if (secret == 12345) { }    // ❌ COMPILER ERROR (use FHE.eq() instead)
```

### ✅ RIGHT: Use FHE Functions

```solidity
euint32 secret = FHE.asEuint32(12345);

// Correct comparison
ebool isGreater = FHE.gt(secret, FHE.asEuint32(100));  // ✅ Correct

// Correct equality
ebool isEqual = FHE.eq(secret, FHE.asEuint32(12345));  // ✅ Correct

// Can't read isGreater either - it's encrypted
if (isGreater) { }  // ❌ Can't use directly

// Use FHE.select() to conditionally branch
result = FHE.select(isGreater, valueIfTrue, valueIfFalse);  // ✅ Correct
```

### ❌ WRONG: Forgetting Access Control

```solidity
// Create encrypted value without granting permissions
euint32 encryptedSecret = FHE.asEuint32(12345);
orders[1].encryptedSecret = encryptedSecret;

// Now NO ONE can use this value - it's locked away!
// Suppliers can't decrypt it, contract can't use it
```

### ✅ RIGHT: Grant Proper Permissions

```solidity
// Create encrypted value
euint32 encryptedSecret = FHE.asEuint32(12345);
orders[1].encryptedSecret = encryptedSecret;

// Grant permissions
FHE.allowThis(encryptedSecret);          // Contract can compute with it
FHE.allow(encryptedSecret, buyer);       // Buyer can decrypt it
FHE.allow(encryptedSecret, supplier);    // Supplier can decrypt it
```

### ❌ WRONG: Mixing Encrypted and Plain Values Incorrectly

```solidity
// Creating encrypted values from untrusted input without validation
function orderByUser(bytes calldata encryptedData) external {
    // Decrypt directly without verification
    euint32 value = FHE.asEuint32(decryptedUserData);
    // Could be any value!
}
```

### ✅ RIGHT: Proper Input Handling

```solidity
// User submits PLAIN values, contract encrypts them
function createOrder(
    uint32 _drugId,        // Plain value from user
    uint32 _quantity,      // Plain value from user
    uint64 _maxBudget      // Plain value from user
) external {
    // Validate user input first
    require(_drugId > 0, "Invalid drug ID");
    require(_quantity > 0, "Invalid quantity");
    require(_maxBudget > 0, "Invalid budget");

    // Then encrypt
    euint32 encryptedDrugId = FHE.asEuint32(_drugId);
    euint32 encryptedQuantity = FHE.asEuint32(_quantity);
    euint64 encryptedBudget = FHE.asEuint64(_maxBudget);

    // Store encrypted values securely
    // ...
}
```

## Real-World Applications

### Healthcare/Pharmaceutical
- **Patient Records**: Store encrypted health data, computations without revealing
- **Medication Pricing**: Compare drug prices across suppliers without revealing actual costs
- **Supply Chain**: Track inventory with encrypted quantities
- **Insurance Claims**: Process claims without revealing diagnosis

### Finance
- **Secure Auctions**: Private bidding where bids stay encrypted until winner is selected
- **Credit Scoring**: Compute credit without revealing full financial details
- **Fraud Detection**: Analyze patterns without exposing customer data
- **DeFi Derivatives**: Price discovery without revealing positions

### E-Commerce
- **Price Matching**: Find best supplier without revealing individual bids
- **Inventory Management**: Aggregate stock levels across warehouses (encrypted)
- **Demand Forecasting**: Analyze purchasing patterns (encrypted)
- **Recommendation Engines**: Train models on encrypted user behavior

### Governance
- **Secret Voting**: Tally votes without revealing individual choices
- **Proposal Scoring**: Aggregate opinions (encrypted) then reveal results
- **Audit Trails**: Track sensitive operations without exposing details
- **Compliance**: Check regulatory conditions on encrypted data

## Additional Resources

- [Zama FHEVM Documentation](https://docs.zama.ai/fhevm)
- [FHE Concepts Whitepaper](https://eprint.iacr.org/2012/144)
- [Encrypted Computation in Blockchain](https://docs.zama.ai/fhevm/fundamentals)

---

**Chapter Tags Used in PrivacyPharma:**
- `chapter: encryption` - Encrypted data types and storage
- `chapter: access-control` - Permission management patterns
- `chapter: private-computation` - FHE operations on encrypted data
- `chapter: public-decryption` - Async decryption workflows
- `chapter: anti-patterns` - What not to do

See test suite (`test/PrivacyPharma.test.js`) for practical examples of each concept.
