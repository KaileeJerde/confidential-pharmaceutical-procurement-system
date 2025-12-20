// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title User Decrypt Single Value
/// @notice Demonstrates how users can decrypt their own encrypted values
/// @dev Shows permission patterns and user-side decryption
/// @custom:category basic
/// @custom:chapter user-decryption, access-control
contract UserDecryptSingle is ZamaEthereumConfig {
    mapping(address => euint32) public userSecretValues;

    event ValueStored(address indexed user);
    event PermissionGranted(address indexed user, address indexed viewer);

    /// @notice Stores an encrypted value for the user
    /// @param inputValue The encrypted value to store
    /// @param inputProof Zero-knowledge proof for the input
    /// @dev User can later decrypt this value client-side
    /// @custom:pattern User stores encrypted value
    function storeMyValue(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        euint32 encryptedValue = FHE.fromExternal(inputValue, inputProof);

        userSecretValues[msg.sender] = encryptedValue;

        // Grant permissions
        FHE.allowThis(encryptedValue);
        FHE.allow(encryptedValue, msg.sender); // User can decrypt

        emit ValueStored(msg.sender);
    }

    /// @notice Retrieves the encrypted value for decryption
    /// @return The encrypted value handle
    /// @dev User decrypts this client-side using their private key
    /// @custom:example User-side decryption pattern
    /// The actual decryption happens in the client application:
    /// ```typescript
    /// const handle = await contract.getMyValue();
    /// const plaintext = await fhevm.decrypt(handle, userPrivateKey);
    /// ```
    function getMyValue() external view returns (euint32) {
        return userSecretValues[msg.sender];
    }

    /// @notice Grants another user permission to decrypt my value
    /// @param viewer The address to grant permission to
    /// @dev Shows how to share encrypted data with specific users
    /// @custom:pattern Sharing encrypted data
    function shareWithUser(address viewer) external {
        euint32 myValue = userSecretValues[msg.sender];
        require(FHE.isInitialized(myValue), "No value stored");

        // Grant viewer permission to decrypt
        FHE.allow(myValue, viewer);

        emit PermissionGranted(msg.sender, viewer);
    }

    /// @notice Retrieves another user's shared value
    /// @param owner The address of the value owner
    /// @return The encrypted value handle (if permission granted)
    /// @dev Only works if owner called shareWithUser for msg.sender
    function getSharedValue(address owner) external view returns (euint32) {
        return userSecretValues[owner];
    }

    /// @notice Updates the stored encrypted value
    /// @param inputValue The new encrypted value
    /// @param inputProof Zero-knowledge proof for the input
    /// @dev Old value is overwritten, permissions must be re-granted
    function updateMyValue(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        euint32 newValue = FHE.fromExternal(inputValue, inputProof);

        userSecretValues[msg.sender] = newValue;

        FHE.allowThis(newValue);
        FHE.allow(newValue, msg.sender);

        emit ValueStored(msg.sender);
    }

    /// @notice Checks if a value is stored for the user
    /// @return True if user has a stored value, false otherwise
    function hasStoredValue() external view returns (bool) {
        return FHE.isInitialized(userSecretValues[msg.sender]);
    }

    /// @notice Example of INCORRECT pattern - trying to return plaintext in view
    /// @return This will NOT work - cannot decrypt in view function
    /// @dev ❌ ANTI-PATTERN: View functions cannot decrypt
    /// @custom:antipattern Cannot decrypt in view function
    function getMyValuePlaintext() external view returns (uint32) {
        // ❌ WRONG: This would require decryption in a view function
        // which is not supported in FHEVM
        // return FHE.decrypt(userSecretValues[msg.sender]);

        // Correct approach: Return encrypted handle and decrypt client-side
        revert("Cannot decrypt in view function. Use getMyValue() and decrypt client-side.");
    }

    /// @notice Example of CORRECT pattern - storing and retrieving for decryption
    /// @dev ✅ CORRECT: Store encrypted, return handle, decrypt client-side
    /// @custom:pattern Correct user decryption workflow
    ///
    /// Complete workflow:
    /// 1. User encrypts value client-side
    /// 2. User submits encrypted value with proof to storeMyValue()
    /// 3. Contract stores encrypted value with user permission
    /// 4. User retrieves encrypted handle with getMyValue()
    /// 5. User decrypts handle client-side with their key
    function demonstrateCorrectPattern(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        // Store encrypted value
        euint32 encrypted = FHE.fromExternal(inputValue, inputProof);
        userSecretValues[msg.sender] = encrypted;

        // Grant permissions for later retrieval and decryption
        FHE.allowThis(encrypted);
        FHE.allow(encrypted, msg.sender);

        // User can now call getMyValue() to get handle for decryption
        emit ValueStored(msg.sender);
    }
}
