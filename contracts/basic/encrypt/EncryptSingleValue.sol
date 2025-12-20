// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Encrypt Single Value - FHEVM Encryption Example
/// @notice Demonstrates how to encrypt a single value and common pitfalls
/// @dev Shows correct encryption patterns and access control
/// @custom:category basic
/// @custom:chapter encryption, access-control, input-proofs
contract EncryptSingleValue is ZamaEthereumConfig {
    mapping(address => euint32) public userValues;

    event ValueStored(address indexed user);

    /// @notice Stores an encrypted value for the caller
    /// @param inputValue The encrypted input value
    /// @param inputProof The zero-knowledge proof for the input
    /// @dev Demonstrates correct encryption and permission pattern
    /// @custom:pattern ✅ CORRECT: Using input proofs for external encrypted values
    function storeValue(externalEuint32 inputValue, bytes calldata inputProof) external {
        // ✅ CORRECT: Convert external encrypted input with proof verification
        // This ensures the caller actually knows the plaintext value
        euint32 encryptedValue = FHE.fromExternal(inputValue, inputProof);

        // Store the encrypted value
        userValues[msg.sender] = encryptedValue;

        // ✅ CORRECT: Grant permissions in the right order
        // 1. Contract needs permission to use the value
        FHE.allowThis(encryptedValue);
        // 2. User needs permission to decrypt their own value
        FHE.allow(encryptedValue, msg.sender);

        emit ValueStored(msg.sender);
    }

    /// @notice Retrieves the user's encrypted value
    /// @return The encrypted value handle
    /// @dev Only returns the handle; actual decryption happens off-chain
    function getValue() external view returns (euint32) {
        return userValues[msg.sender];
    }

    /// @notice Example of ANTI-PATTERN - Missing allowThis permission
    /// @param inputValue The encrypted input value
    /// @param inputProof The zero-knowledge proof for the input
    /// @dev ❌ ANTI-PATTERN: This will fail in real usage
    /// @custom:antipattern Missing FHE.allowThis() permission
    function storeValueWrong(externalEuint32 inputValue, bytes calldata inputProof) external {
        euint32 encryptedValue = FHE.fromExternal(inputValue, inputProof);
        userValues[msg.sender] = encryptedValue;

        // ❌ WRONG: Missing FHE.allowThis(encryptedValue)
        // The contract won't be able to use this value in future operations
        FHE.allow(encryptedValue, msg.sender);
    }

    /// @notice Stores a value without input proof
    /// @param plainValue The plaintext value to encrypt
    /// @dev Use this pattern only when contract itself creates the encrypted value
    /// @custom:pattern Internal encryption without external input
    function storeInternalValue(uint32 plainValue) external {
        // ✅ CORRECT: When contract creates encrypted value from plaintext
        // No input proof needed because it's not external input
        euint32 encryptedValue = FHE.asEuint32(plainValue);

        userValues[msg.sender] = encryptedValue;

        FHE.allowThis(encryptedValue);
        FHE.allow(encryptedValue, msg.sender);

        emit ValueStored(msg.sender);
    }
}
