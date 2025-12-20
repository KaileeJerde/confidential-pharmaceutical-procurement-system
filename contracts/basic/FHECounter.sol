// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title FHE Counter - Basic FHEVM Example
/// @notice Demonstrates fundamental FHEVM concepts with an encrypted counter
/// @dev This contract shows encryption, FHE operations, and access control
/// @custom:category basic
/// @custom:chapter encryption, access-control, fhe-operations
contract FHECounter is ZamaEthereumConfig {
    euint32 private _count;

    event CountIncremented(address indexed user);
    event CountDecremented(address indexed user);

    /// @notice Returns the current encrypted count
    /// @return The current count as an encrypted uint32 handle
    /// @dev The returned handle can be decrypted by authorized addresses
    function getCount() external view returns (euint32) {
        return _count;
    }

    /// @notice Increments the counter by a specified encrypted value
    /// @param inputEuint32 The encrypted input value to add
    /// @param inputProof The zero-knowledge proof validating the encrypted input
    /// @dev Demonstrates FHE.add operation and permission management
    /// @custom:example
    /// ```typescript
    /// const encInput = await fhevm.createEncryptedInput(contractAddress, alice.address);
    /// encInput.add32(5);
    /// const { handles, inputProof } = encInput.encrypt();
    /// await contract.connect(alice).increment(handles[0], inputProof);
    /// ```
    function increment(externalEuint32 inputEuint32, bytes calldata inputProof) external {
        // Convert external encrypted input to internal format with proof verification
        euint32 encryptedEuint32 = FHE.fromExternal(inputEuint32, inputProof);

        // Perform encrypted addition
        // This operation happens on encrypted data without revealing values
        _count = FHE.add(_count, encryptedEuint32);

        // Grant access permissions
        FHE.allowThis(_count);      // Contract can use the encrypted value
        FHE.allow(_count, msg.sender); // Caller can decrypt the value

        emit CountIncremented(msg.sender);
    }

    /// @notice Decrements the counter by a specified encrypted value
    /// @param inputEuint32 The encrypted input value to subtract
    /// @param inputProof The zero-knowledge proof validating the encrypted input
    /// @dev Demonstrates FHE.sub operation
    /// Note: This example omits underflow checks for simplicity
    function decrement(externalEuint32 inputEuint32, bytes calldata inputProof) external {
        euint32 encryptedEuint32 = FHE.fromExternal(inputEuint32, inputProof);

        // Perform encrypted subtraction
        _count = FHE.sub(_count, encryptedEuint32);

        // Grant access permissions
        FHE.allowThis(_count);
        FHE.allow(_count, msg.sender);

        emit CountDecremented(msg.sender);
    }
}
