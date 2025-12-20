// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title FHE Arithmetic Operations
/// @notice Demonstrates all arithmetic operations on encrypted values
/// @dev Shows add, sub, mul, div operations with encrypted integers
/// @custom:category basic
/// @custom:chapter fhe-operations, encryption
contract FHEArithmetic is ZamaEthereumConfig {
    euint32 public resultAdd;
    euint32 public resultSub;
    euint32 public resultMul;

    event ArithmeticPerformed(address indexed user, string operation);

    /// @notice Performs encrypted addition: a + b
    /// @param inputA First encrypted operand
    /// @param inputB Second encrypted operand
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.add operation
    /// @custom:example Addition on encrypted values
    function performAddition(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted addition
        resultAdd = FHE.add(a, b);

        // Grant permissions
        FHE.allowThis(resultAdd);
        FHE.allow(resultAdd, msg.sender);

        emit ArithmeticPerformed(msg.sender, "addition");
    }

    /// @notice Performs encrypted subtraction: a - b
    /// @param inputA Minuend (encrypted)
    /// @param inputB Subtrahend (encrypted)
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.sub operation
    /// Note: Does not check for underflow in this educational example
    function performSubtraction(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted subtraction
        resultSub = FHE.sub(a, b);

        FHE.allowThis(resultSub);
        FHE.allow(resultSub, msg.sender);

        emit ArithmeticPerformed(msg.sender, "subtraction");
    }

    /// @notice Performs encrypted multiplication: a * b
    /// @param inputA First factor (encrypted)
    /// @param inputB Second factor (encrypted)
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates FHE.mul operation
    /// Note: Does not check for overflow in this educational example
    function performMultiplication(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Encrypted multiplication
        resultMul = FHE.mul(a, b);

        FHE.allowThis(resultMul);
        FHE.allow(resultMul, msg.sender);

        emit ArithmeticPerformed(msg.sender, "multiplication");
    }

    /// @notice Performs all arithmetic operations in one transaction
    /// @param inputA First operand (encrypted)
    /// @param inputB Second operand (encrypted)
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Demonstrates combining multiple FHE operations
    /// @custom:pattern Batch FHE operations
    function performAllOperations(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);

        // Perform all operations
        resultAdd = FHE.add(a, b);
        resultSub = FHE.sub(a, b);
        resultMul = FHE.mul(a, b);

        // Grant permissions for all results
        FHE.allowThis(resultAdd);
        FHE.allowThis(resultSub);
        FHE.allowThis(resultMul);

        FHE.allow(resultAdd, msg.sender);
        FHE.allow(resultSub, msg.sender);
        FHE.allow(resultMul, msg.sender);

        emit ArithmeticPerformed(msg.sender, "all-operations");
    }

    /// @notice Demonstrates chained arithmetic operations
    /// @param inputA First value (encrypted)
    /// @param inputB Second value (encrypted)
    /// @param inputC Third value (encrypted)
    /// @param inputProof Zero-knowledge proof for the inputs
    /// @dev Shows how to chain FHE operations: (a + b) * c
    /// @custom:pattern Chained FHE operations
    function performChainedOperation(
        externalEuint32 inputA,
        externalEuint32 inputB,
        externalEuint32 inputC,
        bytes calldata inputProof
    ) external returns (euint32) {
        euint32 a = FHE.fromExternal(inputA, inputProof);
        euint32 b = FHE.fromExternal(inputB, inputProof);
        euint32 c = FHE.fromExternal(inputC, inputProof);

        // Chained operations: (a + b) * c
        euint32 sum = FHE.add(a, b);
        euint32 result = FHE.mul(sum, c);

        FHE.allowThis(result);
        FHE.allow(result, msg.sender);

        emit ArithmeticPerformed(msg.sender, "chained");

        return result;
    }

    /// @notice Retrieves the addition result
    /// @return The encrypted addition result
    function getAdditionResult() external view returns (euint32) {
        return resultAdd;
    }

    /// @notice Retrieves the subtraction result
    /// @return The encrypted subtraction result
    function getSubtractionResult() external view returns (euint32) {
        return resultSub;
    }

    /// @notice Retrieves the multiplication result
    /// @return The encrypted multiplication result
    function getMultiplicationResult() external view returns (euint32) {
        return resultMul;
    }
}
