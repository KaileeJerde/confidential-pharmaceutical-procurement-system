// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, ebool, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title FHE Comparison Operations
/// @notice Demonstrates all comparison operations on encrypted values
/// @dev Shows eq, ne, lt, le, gt, ge operations with encrypted integers
/// @custom:category basic
/// @custom:chapter fhe-operations, private-computation
contract FHEComparison is ZamaEthereumConfig {
    ebool public resultEqual;
    ebool public resultNotEqual;
    ebool public resultLessThan;
    ebool public resultLessOrEqual;
    ebool public resultGreaterThan;
    ebool public resultGreaterOrEqual;

    event ComparisonPerformed(address indexed user, string operation);

    /// @notice Performs encrypted equality comparison: a == b
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.eq operation
    /// @custom:example Equality comparison on encrypted values
    function compareEqual(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted equality comparison
        resultEqual = FHE.eq(a, b);

        FHE.allowThis(resultEqual);
        FHE.allow(resultEqual, msg.sender);

        emit ComparisonPerformed(msg.sender, "equal");
    }

    /// @notice Performs encrypted inequality comparison: a != b
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.ne operation
    function compareNotEqual(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted inequality comparison
        resultNotEqual = FHE.ne(a, b);

        FHE.allowThis(resultNotEqual);
        FHE.allow(resultNotEqual, msg.sender);

        emit ComparisonPerformed(msg.sender, "not-equal");
    }

    /// @notice Performs encrypted less-than comparison: a < b
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.lt operation
    function compareLessThan(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted less-than comparison
        resultLessThan = FHE.lt(a, b);

        FHE.allowThis(resultLessThan);
        FHE.allow(resultLessThan, msg.sender);

        emit ComparisonPerformed(msg.sender, "less-than");
    }

    /// @notice Performs encrypted less-or-equal comparison: a <= b
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.le operation
    function compareLessOrEqual(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted less-or-equal comparison
        resultLessOrEqual = FHE.le(a, b);

        FHE.allowThis(resultLessOrEqual);
        FHE.allow(resultLessOrEqual, msg.sender);

        emit ComparisonPerformed(msg.sender, "less-or-equal");
    }

    /// @notice Performs encrypted greater-than comparison: a > b
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.gt operation
    function compareGreaterThan(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted greater-than comparison
        resultGreaterThan = FHE.gt(a, b);

        FHE.allowThis(resultGreaterThan);
        FHE.allow(resultGreaterThan, msg.sender);

        emit ComparisonPerformed(msg.sender, "greater-than");
    }

    /// @notice Performs encrypted greater-or-equal comparison: a >= b
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.ge operation
    function compareGreaterOrEqual(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted greater-or-equal comparison
        resultGreaterOrEqual = FHE.ge(a, b);

        FHE.allowThis(resultGreaterOrEqual);
        FHE.allow(resultGreaterOrEqual, msg.sender);

        emit ComparisonPerformed(msg.sender, "greater-or-equal");
    }

    /// @notice Performs all comparison operations in one transaction
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates combining multiple FHE comparison operations
    /// @custom:pattern Batch comparison operations
    function performAllComparisons(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Perform all comparisons
        resultEqual = FHE.eq(a, b);
        resultNotEqual = FHE.ne(a, b);
        resultLessThan = FHE.lt(a, b);
        resultLessOrEqual = FHE.le(a, b);
        resultGreaterThan = FHE.gt(a, b);
        resultGreaterOrEqual = FHE.ge(a, b);

        // Grant permissions for all results
        FHE.allowThis(resultEqual);
        FHE.allowThis(resultNotEqual);
        FHE.allowThis(resultLessThan);
        FHE.allowThis(resultLessOrEqual);
        FHE.allowThis(resultGreaterThan);
        FHE.allowThis(resultGreaterOrEqual);

        FHE.allow(resultEqual, msg.sender);
        FHE.allow(resultNotEqual, msg.sender);
        FHE.allow(resultLessThan, msg.sender);
        FHE.allow(resultLessOrEqual, msg.sender);
        FHE.allow(resultGreaterThan, msg.sender);
        FHE.allow(resultGreaterOrEqual, msg.sender);

        emit ComparisonPerformed(msg.sender, "all-comparisons");
    }

    /// @notice Demonstrates using comparison results in conditional logic
    /// @param inputA First encrypted value
    /// @param inputB Second encrypted value
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @return Selected value based on comparison
    /// @dev Shows FHE.select with comparison result
    /// @custom:pattern Conditional selection with encrypted comparison
    function selectBasedOnComparison(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external returns (euint32) {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Compare: is a greater than b?
        ebool isGreater = FHE.gt(a, b);

        // Select max value: if (a > b) return a else return b
        euint32 maxValue = FHE.select(isGreater, a, b);

        FHE.allowThis(maxValue);
        FHE.allow(maxValue, msg.sender);

        emit ComparisonPerformed(msg.sender, "conditional-select");

        return maxValue;
    }

    /// @notice Retrieves all comparison results
    /// @return eq Result of equality comparison
    /// @return ne Result of inequality comparison
    /// @return lt Result of less-than comparison
    /// @return le Result of less-or-equal comparison
    /// @return gt Result of greater-than comparison
    /// @return ge Result of greater-or-equal comparison
    function getAllResults() external view returns (
        ebool eq,
        ebool ne,
        ebool lt,
        ebool le,
        ebool gt,
        ebool ge
    ) {
        return (
            resultEqual,
            resultNotEqual,
            resultLessThan,
            resultLessOrEqual,
            resultGreaterThan,
            resultGreaterOrEqual
        );
    }
}
