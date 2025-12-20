// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title A simple FHE counter contract
/// @notice A basic example contract demonstrating encrypted data operations using FHEVM
/// @dev This contract shows fundamental FHEVM concepts: encryption, FHE operations, and access control
contract FHECounter is ZamaEthereumConfig {
    euint32 private _count;

    /// @notice Returns the current encrypted count
    /// @return The current count as an encrypted uint32
    function getCount() external view returns (euint32) {
        return _count;
    }

    /// @notice Increments the counter by a specified encrypted value
    /// @param inputEuint32 The encrypted input value to add
    /// @param inputProof The zero-knowledge proof that validates the encrypted input
    /// @dev This example omits overflow checks for simplicity
    /// In production, implement proper range validation
    function increment(externalEuint32 inputEuint32, bytes calldata inputProof) external {
        // Convert external encrypted input to internal format
        euint32 encryptedEuint32 = FHE.fromExternal(inputEuint32, inputProof);

        // Perform encrypted addition
        _count = FHE.add(_count, encryptedEuint32);

        // Grant access permissions
        FHE.allowThis(_count);      // Contract can use the encrypted value
        FHE.allow(_count, msg.sender); // Caller can decrypt the value
    }

    /// @notice Decrements the counter by a specified encrypted value
    /// @param inputEuint32 The encrypted input value to subtract
    /// @param inputProof The zero-knowledge proof that validates the encrypted input
    /// @dev This example omits underflow checks for simplicity
    /// In production, implement proper range validation
    function decrement(externalEuint32 inputEuint32, bytes calldata inputProof) external {
        // Convert external encrypted input to internal format
        euint32 encryptedEuint32 = FHE.fromExternal(inputEuint32, inputProof);

        // Perform encrypted subtraction
        _count = FHE.sub(_count, encryptedEuint32);

        // Grant access permissions
        FHE.allowThis(_count);      // Contract can use the encrypted value
        FHE.allow(_count, msg.sender); // Caller can decrypt the value
    }
}
