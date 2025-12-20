# Complete Examples List

This document lists all available FHEVM examples included in this hub.

## Basic Examples (10 examples)

### 1. FHE Counter
- **Contract**: `contracts/basic/FHECounter.sol`
- **Test**: `test/basic/FHECounter.test.ts`
- **Concepts**: Basic encryption, FHE operations, access control
- **Generate**: `npm run create:example fhe-counter ./output/fhe-counter`

### 2. Encrypt Single Value
- **Contract**: `contracts/basic/encrypt/EncryptSingleValue.sol`
- **Test**: `test/basic/encrypt/EncryptSingleValue.test.ts`
- **Concepts**: Encryption mechanism, input proofs, anti-patterns
- **Generate**: `npm run create:example encrypt-single-value ./output/encrypt-single`

### 3. Encrypt Multiple Values
- **Contract**: `contracts/basic/encrypt/EncryptMultipleValues.sol`
- **Test**: `test/basic/encrypt/EncryptMultipleValues.test.ts`
- **Concepts**: Batch encryption, combined proofs, efficient patterns
- **Generate**: `npm run create:example encrypt-multiple-values ./output/encrypt-multiple`

### 4. User Decrypt Single
- **Contract**: `contracts/basic/decrypt/UserDecryptSingle.sol`
- **Test**: `test/basic/decrypt/UserDecryptSingle.test.ts`
- **Concepts**: User-side decryption, permission management
- **Generate**: `npm run create:example user-decrypt-single ./output/user-decrypt`

### 5. Public Decrypt Single
- **Contract**: `contracts/basic/decrypt/PublicDecryptSingle.sol`
- **Test**: `test/basic/decrypt/PublicDecryptSingle.test.ts`
- **Concepts**: Async decryption, callbacks, public reveal
- **Generate**: `npm run create:example public-decrypt-single ./output/public-decrypt`

### 6. FHE Arithmetic
- **Contract**: `contracts/basic/operations/FHEArithmetic.sol`
- **Test**: `test/basic/operations/FHEArithmetic.test.ts`
- **Concepts**: FHE.add, FHE.sub, FHE.mul, chained operations
- **Generate**: `npm run create:example fhe-arithmetic ./output/fhe-arithmetic`

### 7. FHE Comparison
- **Contract**: `contracts/basic/operations/FHEComparison.sol`
- **Test**: `test/basic/operations/FHEComparison.test.ts`
- **Concepts**: FHE.eq, FHE.lt, FHE.gt, FHE.le, FHE.ge, FHE.ne
- **Generate**: `npm run create:example fhe-comparison ./output/fhe-comparison`

### 8. Access Control Example
- **Contract**: `contracts/basic/AccessControlExample.sol`
- **Test**: `test/basic/AccessControlExample.test.ts`
- **Concepts**: FHE.allow, FHE.allowThis, FHE.allowTransient, permission patterns
- **Generate**: `npm run create:example access-control ./output/access-control`

### 9. Input Proof Example
- **Contract**: `contracts/basic/InputProofExample.sol`
- **Test**: `test/basic/InputProofExample.test.ts`
- **Concepts**: What are input proofs, why needed, security guarantees
- **Generate**: `npm run create:example input-proofs ./output/input-proofs`

### 10. Handles Example
- **Contract**: `contracts/basic/HandlesExample.sol`
- **Test**: `test/basic/HandlesExample.test.ts`
- **Concepts**: Understanding handles, lifecycle, operations
- **Generate**: `npm run create:example handles ./output/handles`

## Advanced Examples (1 example)

### 11. Privacy Pharmaceutical Procurement
- **Contract**: `contracts/advanced/PrivacyPharma.sol`
- **Test**: `test/advanced/PrivacyPharma.test.js`
- **Concepts**:
  - Encrypted order creation
  - Private bid submission
  - Encrypted supplier matching
  - Selective decryption
  - Encrypted reputation system
- **Generate**: `npm run create:example privacy-pharmaceutical ./output/privacy-pharma`
- **Lines of Code**: 340+ (contract) + 300+ (tests)

## Category Projects

Generate multiple examples together:

### Basic Category (3 contracts)
```bash
ts-node scripts/create-fhevm-category.ts basic ./output/basic-examples
```
Includes:
- FHECounter
- EncryptSingleValue
- EncryptMultipleValues

### Encryption Category (2 contracts)
```bash
ts-node scripts/create-fhevm-category.ts encryption ./output/encryption-examples
```
Includes:
- EncryptSingleValue
- EncryptMultipleValues

### Decryption Category (2 contracts)
```bash
ts-node scripts/create-fhevm-category.ts decryption ./output/decryption-examples
```
Includes:
- UserDecryptSingle
- PublicDecryptSingle

### Operations Category (2 contracts)
```bash
ts-node scripts/create-fhevm-category.ts operations ./output/operations-examples
```
Includes:
- FHEArithmetic
- FHEComparison

### Concepts Category (3 contracts)
```bash
ts-node scripts/create-fhevm-category.ts concepts ./output/concepts-examples
```
Includes:
- AccessControlExample
- InputProofExample
- HandlesExample

### Advanced Category (1 contract)
```bash
ts-node scripts/create-fhevm-category.ts advanced ./output/advanced-examples
```
Includes:
- PrivacyPharma

## FHEVM Concepts Covered

### Encryption
- ✅ euint8, euint16, euint32, euint64 types
- ✅ ebool type
- ✅ FHE.asEuintX() for internal encryption
- ✅ FHE.fromExternal() for user inputs
- ✅ Single value encryption
- ✅ Batch encryption
- ✅ Input proof validation

### Decryption
- ✅ User-side decryption patterns
- ✅ Public decryption workflow
- ✅ Async decryption with callbacks
- ✅ FHE.requestDecryption()
- ✅ Batch decryption

### Access Control
- ✅ FHE.allow() - Grant user permission
- ✅ FHE.allowThis() - Grant contract permission
- ✅ FHE.allowTransient() - Temporary permissions
- ✅ Permission management patterns
- ✅ Sharing encrypted data

### FHE Operations
- ✅ Arithmetic: add, sub, mul
- ✅ Comparison: eq, ne, lt, le, gt, ge
- ✅ Logic: and, or, not
- ✅ Conditional: select
- ✅ Chained operations

### Advanced Concepts
- ✅ Input proofs
- ✅ Handles lifecycle
- ✅ Encrypted state management
- ✅ Private computation
- ✅ Sealed-bid auctions
- ✅ Multi-criteria selection

## Testing Coverage

All examples include comprehensive tests demonstrating:

- ✅ Correct usage patterns
- ✅ Anti-patterns to avoid
- ✅ Edge cases
- ✅ Integration scenarios
- ✅ Security considerations

## Documentation

Each example has:

- ✅ Detailed inline comments
- ✅ NatSpec documentation
- ✅ Usage examples
- ✅ Common pitfalls
- ✅ Best practices

## Quick Reference

| Example | Complexity | Lines | Key Concepts |
|---------|-----------|-------|--------------|
| FHE Counter | ⭐ Basic | ~50 | Encryption, operations |
| Encrypt Single | ⭐ Basic | ~100 | Input proofs, anti-patterns |
| Encrypt Multiple | ⭐ Basic | ~150 | Batch encryption |
| User Decrypt | ⭐⭐ Intermediate | ~120 | User decryption, sharing |
| Public Decrypt | ⭐⭐ Intermediate | ~140 | Async decryption, callbacks |
| FHE Arithmetic | ⭐⭐ Intermediate | ~160 | Arithmetic operations |
| FHE Comparison | ⭐⭐ Intermediate | ~180 | Comparison operations |
| Access Control | ⭐⭐ Intermediate | ~220 | Permission management |
| Input Proofs | ⭐⭐ Intermediate | ~180 | Security concepts |
| Handles | ⭐⭐ Intermediate | ~200 | Understanding handles |
| Privacy Pharma | ⭐⭐⭐ Advanced | ~340 | Real-world application |

## Learning Path

### Beginner (Start Here)
1. FHE Counter
2. Encrypt Single Value
3. Access Control Example

### Intermediate
4. Encrypt Multiple Values
5. User Decrypt Single
6. FHE Arithmetic
7. FHE Comparison

### Advanced
8. Input Proof Example
9. Handles Example
10. Public Decrypt Single
11. Privacy Pharmaceutical

## All Examples Command

Generate all examples at once:

```bash
# Create output directory
mkdir -p output

# Generate all basic examples
for example in fhe-counter encrypt-single-value encrypt-multiple-values \
               user-decrypt-single public-decrypt-single fhe-arithmetic \
               fhe-comparison access-control input-proofs handles; do
  npm run create:example $example ./output/$example
done

# Generate advanced example
npm run create:example privacy-pharmaceutical ./output/privacy-pharmaceutical
```

## Statistics

- **Total Examples**: 11
- **Basic Examples**: 10
- **Advanced Examples**: 1
- **Total Contracts**: ~1,800 lines
- **Total Tests**: ~1,200 lines
- **FHEVM Concepts**: 20+
- **Categories**: 6

---

**Start exploring:** Pick any example and run `npm run create:example <name> ./output/<name>`!
