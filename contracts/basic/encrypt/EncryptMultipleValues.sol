// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, euint64, externalEuint32, externalEuint64} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Encrypt Multiple Values - FHEVM Batch Encryption Example
/// @notice Demonstrates how to handle multiple encrypted values efficiently
/// @dev Shows batch encryption patterns and multi-value operations
/// @custom:category basic
/// @custom:chapter encryption, access-control
contract EncryptMultipleValues is ZamaEthereumConfig {
    struct UserData {
        euint32 age;
        euint64 balance;
        euint32 score;
    }

    mapping(address => UserData) public userData;

    event DataStored(address indexed user);

    /// @notice Stores multiple encrypted values for a user
    /// @param inputAge Encrypted age value
    /// @param ageProof Proof for age
    /// @param inputBalance Encrypted balance value
    /// @param balanceProof Proof for balance
    /// @param inputScore Encrypted score value
    /// @param scoreProof Proof for score
    /// @dev Demonstrates handling multiple encrypted inputs
    /// @custom:example Batch encryption pattern
    function storeUserData(
        externalEuint32 inputAge,
        bytes calldata ageProof,
        externalEuint64 inputBalance,
        bytes calldata balanceProof,
        externalEuint32 inputScore,
        bytes calldata scoreProof
    ) external {
        // Convert all external inputs to internal encrypted values
        euint32 encryptedAge = FHE.fromExternal(inputAge, ageProof);
        euint64 encryptedBalance = FHE.fromExternal(inputBalance, balanceProof);
        euint32 encryptedScore = FHE.fromExternal(inputScore, scoreProof);

        // Store in struct
        userData[msg.sender] = UserData({
            age: encryptedAge,
            balance: encryptedBalance,
            score: encryptedScore
        });

        // Grant permissions for all values
        FHE.allowThis(encryptedAge);
        FHE.allowThis(encryptedBalance);
        FHE.allowThis(encryptedScore);

        FHE.allow(encryptedAge, msg.sender);
        FHE.allow(encryptedBalance, msg.sender);
        FHE.allow(encryptedScore, msg.sender);

        emit DataStored(msg.sender);
    }

    /// @notice Alternative: Store using single combined proof
    /// @param inputAge Encrypted age value
    /// @param inputBalance Encrypted balance value
    /// @param inputScore Encrypted score value
    /// @param combinedProof Combined proof for all values
    /// @dev More efficient when using createEncryptedInput() batch API
    /// @custom:pattern Optimized batch encryption with single proof
    function storeUserDataOptimized(
        externalEuint32 inputAge,
        externalEuint64 inputBalance,
        externalEuint32 inputScore,
        bytes calldata combinedProof
    ) external {
        // All values can share the same proof when created together
        euint32 encryptedAge = FHE.fromExternal(inputAge, combinedProof);
        euint64 encryptedBalance = FHE.fromExternal(inputBalance, combinedProof);
        euint32 encryptedScore = FHE.fromExternal(inputScore, combinedProof);

        userData[msg.sender] = UserData({
            age: encryptedAge,
            balance: encryptedBalance,
            score: encryptedScore
        });

        // Batch permission grants
        FHE.allowThis(encryptedAge);
        FHE.allowThis(encryptedBalance);
        FHE.allowThis(encryptedScore);

        FHE.allow(encryptedAge, msg.sender);
        FHE.allow(encryptedBalance, msg.sender);
        FHE.allow(encryptedScore, msg.sender);

        emit DataStored(msg.sender);
    }

    /// @notice Retrieves all user data
    /// @return age Encrypted age handle
    /// @return balance Encrypted balance handle
    /// @return score Encrypted score handle
    function getUserData() external view returns (euint32 age, euint64 balance, euint32 score) {
        UserData storage data = userData[msg.sender];
        return (data.age, data.balance, data.score);
    }
}
