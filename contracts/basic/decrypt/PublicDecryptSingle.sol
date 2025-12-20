// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Public Decrypt Single Value
/// @notice Demonstrates asynchronous public decryption workflow
/// @dev Shows how to request decryption and process decrypted values
/// @custom:category basic
/// @custom:chapter public-decryption, async-operations
contract PublicDecryptSingle is ZamaEthereumConfig {
    euint32 public encryptedValue;
    uint32 public decryptedValue;
    bool public isDecrypted;

    mapping(address => euint32) private userValues;
    mapping(address => uint32) private revealedValues;

    event ValueStored(address indexed user);
    event DecryptionRequested(address indexed requester);
    event ValueRevealed(address indexed user, uint32 value);

    /// @notice Stores an encrypted value
    /// @param inputValue The encrypted input
    /// @param inputProof Zero-knowledge proof for the input
    /// @dev Value remains encrypted until decryption is requested
    function storeEncryptedValue(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        euint32 encrypted = FHE.fromExternal(inputValue, inputProof);

        userValues[msg.sender] = encrypted;
        encryptedValue = encrypted;

        FHE.allowThis(encrypted);
        FHE.allow(encrypted, msg.sender);

        emit ValueStored(msg.sender);
    }

    /// @notice Requests asynchronous decryption of the stored value
    /// @dev Demonstrates the async decryption request pattern
    /// @custom:example Requesting public decryption
    /// This initiates a decryption request that will be processed
    /// by the FHE network and returned via callback
    function requestDecryption() external {
        require(FHE.isInitialized(encryptedValue), "No value to decrypt");

        // Prepare encrypted value for decryption
        bytes32[] memory cts = new bytes32[](1);
        cts[0] = FHE.toBytes32(encryptedValue);

        // Request async decryption with callback
        FHE.requestDecryption(cts, this.processDecryptedValue.selector);

        emit DecryptionRequested(msg.sender);
    }

    /// @notice Callback function that receives the decrypted value
    /// @param requestId The ID of the decryption request
    /// @param plainValue The decrypted value
    /// @param signatures Cryptographic signatures proving decryption validity
    /// @dev This is called by the FHE network after decryption
    /// @custom:pattern Decryption callback
    function processDecryptedValue(
        uint256 requestId,
        uint32 plainValue,
        bytes[] memory signatures
    ) external {
        // In production, verify signatures to ensure decryption validity
        // FHE.checkSignatures(requestId, signatures);

        // Store the decrypted value
        decryptedValue = plainValue;
        isDecrypted = true;

        emit ValueRevealed(msg.sender, plainValue);
    }

    /// @notice Requests decryption of a specific user's value
    /// @param user The address whose value to decrypt
    /// @dev Shows how to decrypt values for specific users
    function requestUserDecryption(address user) external {
        euint32 value = userValues[user];
        require(FHE.isInitialized(value), "User has no stored value");

        bytes32[] memory cts = new bytes32[](1);
        cts[0] = FHE.toBytes32(value);

        FHE.requestDecryption(cts, this.processUserDecryption.selector);

        emit DecryptionRequested(user);
    }

    /// @notice Callback for user-specific decryption
    /// @param requestId The ID of the decryption request
    /// @param plainValue The decrypted value
    /// @param signatures Cryptographic signatures
    /// @dev Processes decrypted value for specific user
    function processUserDecryption(
        uint256 requestId,
        uint32 plainValue,
        bytes[] memory signatures
    ) external {
        // Store revealed value
        // In real implementation, map requestId to user address
        decryptedValue = plainValue;
        isDecrypted = true;
    }

    /// @notice Retrieves the encrypted value
    /// @return The encrypted value handle
    function getEncryptedValue() external view returns (euint32) {
        return encryptedValue;
    }

    /// @notice Retrieves the decrypted value (if available)
    /// @return The plaintext value after decryption
    /// @dev Only returns meaningful value after decryption is processed
    function getDecryptedValue() external view returns (uint32) {
        require(isDecrypted, "Value not yet decrypted");
        return decryptedValue;
    }

    /// @notice Checks if decryption has been completed
    /// @return True if value has been decrypted, false otherwise
    function isValueDecrypted() external view returns (bool) {
        return isDecrypted;
    }

    /// @notice Demonstrates the complete decrypt workflow
    /// @param inputValue The encrypted input
    /// @param inputProof Zero-knowledge proof
    /// @dev Shows all steps: store -> request -> callback -> retrieve
    /// @custom:pattern Complete public decryption workflow
    ///
    /// Workflow:
    /// 1. storeEncryptedValue() - Store encrypted value
    /// 2. requestDecryption() - Initiate async decryption
    /// 3. [FHE network processes decryption]
    /// 4. processDecryptedValue() - Callback receives plaintext
    /// 5. getDecryptedValue() - Retrieve plaintext result
    function demonstrateDecryptionWorkflow(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        // Step 1: Store encrypted value
        euint32 encrypted = FHE.fromExternal(inputValue, inputProof);
        userValues[msg.sender] = encrypted;

        FHE.allowThis(encrypted);

        emit ValueStored(msg.sender);

        // Step 2 would be: call requestDecryption()
        // Step 3 is automatic (FHE network processes)
        // Step 4 is automatic (callback is triggered)
        // Step 5: User can then call getDecryptedValue()
    }

    /// @notice Example of when to use public vs user decryption
    /// @dev ✅ Use public decryption when:
    /// - Contract needs to see plaintext value
    /// - Triggering on-chain logic based on decrypted value
    /// - Making value publicly visible
    ///
    /// ✅ Use user decryption when:
    /// - Only specific user needs to see value
    /// - Maintaining privacy from contract
    /// - Client-side processing sufficient
    function decryptionPatternGuidance() external pure returns (string memory) {
        return "Public decryption: Contract needs plaintext. User decryption: Only user needs plaintext.";
    }
}
