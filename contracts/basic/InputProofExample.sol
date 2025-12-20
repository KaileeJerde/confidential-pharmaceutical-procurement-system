// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Input Proof Example
/// @notice Explains what input proofs are and why they're needed
/// @dev Demonstrates correct and incorrect usage of input proofs
/// @custom:category basic
/// @custom:chapter input-proofs, security
contract InputProofExample is ZamaEthereumConfig {
    mapping(address => euint32) private userSecrets;

    event SecretStored(address indexed user, bool withProof);

    /// @notice What are input proofs?
    /// @dev Input proofs are zero-knowledge proofs that demonstrate:
    /// 1. The user knows the plaintext value being encrypted
    /// 2. The encrypted value is properly bound to the user's address
    /// 3. The encryption was done correctly
    ///
    /// Without input proofs, users could:
    /// - Submit random encrypted data they don't know
    /// - Copy encrypted values from other transactions
    /// - Replay old encrypted values
    ///
    /// @custom:concept Input proofs prevent these attacks
    function whatAreInputProofs() external pure returns (string memory) {
        return "Input proofs are zero-knowledge proofs that validate encrypted inputs";
    }

    /// @notice ✅ CORRECT: Using input proofs for external encrypted values
    /// @param inputValue The encrypted value from user
    /// @param inputProof The zero-knowledge proof
    /// @dev This is the CORRECT way to accept encrypted user input
    /// @custom:pattern Correct input proof usage
    function storeSecretWithProof(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        // ✅ CORRECT: Use FHE.fromExternal with proof
        // This verifies that:
        // - User knows the plaintext
        // - Value is bound to msg.sender
        // - Encryption is valid
        euint32 secret = FHE.fromExternal(inputValue, inputProof);

        userSecrets[msg.sender] = secret;

        FHE.allowThis(secret);
        FHE.allow(secret, msg.sender);

        emit SecretStored(msg.sender, true);
    }

    /// @notice When input proofs are needed
    /// @dev Input proofs are REQUIRED when:
    /// ✅ Accepting encrypted values from users (external inputs)
    /// ✅ User submits encrypted data for the first time
    /// ✅ Processing encrypted form data
    /// ✅ Receiving encrypted parameters in transactions
    ///
    /// Input proofs are NOT needed when:
    /// ❌ Contract creates encrypted value from plaintext
    /// ❌ Contract performs FHE operations on existing encrypted values
    /// ❌ Reading stored encrypted values
    ///
    /// @custom:concept When to use input proofs
    function whenInputProofsAreNeeded() external pure returns (string memory) {
        return "Required for external encrypted inputs from users";
    }

    /// @notice ✅ CORRECT: Contract creates encrypted value (no proof needed)
    /// @param plaintextValue The plaintext value
    /// @dev When contract encrypts plaintext, no proof is needed
    /// @custom:pattern Internal encryption without proof
    function storeSecretFromPlaintext(uint32 plaintextValue) external {
        // ✅ CORRECT: No proof needed when contract encrypts plaintext
        // Contract itself creates the encrypted value
        euint32 secret = FHE.asEuint32(plaintextValue);

        userSecrets[msg.sender] = secret;

        FHE.allowThis(secret);
        FHE.allow(secret, msg.sender);

        emit SecretStored(msg.sender, false);
    }

    /// @notice How input proofs are generated (client-side)
    /// @dev This is informational - showing what happens client-side
    /// @custom:example Client-side proof generation
    ///
    /// Client-side TypeScript example:
    /// ```typescript
    /// // 1. Create encrypted input bound to contract and user
    /// const encryptedInput = await fhevm.createEncryptedInput(
    ///     contractAddress,  // Contract that will receive it
    ///     userAddress       // User submitting it
    /// );
    ///
    /// // 2. Add the plaintext value to be encrypted
    /// encryptedInput.add32(secretValue);
    ///
    /// // 3. Generate encryption and proof
    /// const { handles, inputProof } = encryptedInput.encrypt();
    ///
    /// // 4. Submit to contract
    /// await contract.storeSecretWithProof(handles[0], inputProof);
    /// ```
    function howToGenerateInputProofs() external pure returns (string memory) {
        return "Generated client-side using fhevm.createEncryptedInput()";
    }

    /// @notice ❌ ANTI-PATTERN: Missing input proof
    /// @dev This demonstrates WRONG usage - DO NOT DO THIS
    /// @custom:antipattern Missing input proof validation
    function storeSecretWithoutProof(externalEuint32 inputValue) external {
        // ❌ WRONG: Accepting external encrypted value without proof
        // This is UNSAFE because:
        // - Cannot verify user knows the plaintext
        // - Cannot prevent replay attacks
        // - Cannot validate encryption binding

        // This would fail to compile or cause runtime errors
        // Kept here for educational purposes only

        revert("Missing input proof - this pattern is insecure");
    }

    /// @notice Input proof security guarantees
    /// @dev Input proofs provide these security properties:
    /// 1. Knowledge proof: User knows the plaintext value
    /// 2. Binding proof: Value is bound to user's address
    /// 3. Freshness: Prevents replay of old encrypted values
    /// 4. Correctness: Encryption was performed correctly
    ///
    /// @custom:concept Security guarantees
    function securityGuarantees() external pure returns (string memory) {
        return "Knowledge, binding, freshness, and correctness";
    }

    /// @notice Real-world analogy for input proofs
    /// @dev Think of input proofs like a package tracking system:
    /// - Plaintext value = Package contents
    /// - Encryption = Sealed box
    /// - Input proof = Signed receipt showing:
    ///   * You packed the box (knowledge)
    ///   * Box is addressed to specific recipient (binding)
    ///   * Box hasn't been tampered with (correctness)
    ///   * This is a new shipment, not a duplicate (freshness)
    ///
    /// @custom:concept Real-world analogy
    function realWorldAnalogy() external pure returns (string memory) {
        return "Like a signed receipt for a sealed package";
    }

    /// @notice Performance considerations
    /// @dev Input proof generation and verification costs:
    /// - Client-side proof generation: ~100-200ms
    /// - On-chain verification: ~50k-100k gas
    /// - One proof can cover multiple values (batch encryption)
    ///
    /// Optimization tip: Use createEncryptedInput().add32().add64().add32()
    /// to batch multiple values with a single proof
    ///
    /// @custom:concept Performance
    function performanceConsiderations() external pure returns (string memory) {
        return "Batch multiple values in one proof for efficiency";
    }

    /// @notice Demonstrates batch input proof (multiple values, one proof)
    /// @param input1 First encrypted value
    /// @param input2 Second encrypted value
    /// @param combinedProof Single proof for both values
    /// @dev Shows efficient pattern: one proof for multiple values
    /// @custom:pattern Batch input proof
    function storeTwoSecretsWithOneProof(
        externalEuint32 input1,
        externalEuint32 input2,
        bytes calldata combinedProof
    ) external {
        // ✅ EFFICIENT: One proof validates both encrypted values
        euint32 secret1 = FHE.fromExternal(input1, combinedProof);
        euint32 secret2 = FHE.fromExternal(input2, combinedProof);

        // Use both values...
        FHE.allowThis(secret1);
        FHE.allowThis(secret2);

        // More gas-efficient than separate proofs for each value
        emit SecretStored(msg.sender, true);
    }

    /// @notice Common mistakes with input proofs
    /// @dev ❌ Common mistakes:
    /// 1. Forgetting to include proof parameter
    /// 2. Using same proof for unrelated values
    /// 3. Not generating proof client-side
    /// 4. Mixing up contract and user addresses in proof
    /// 5. Reusing proofs across transactions
    ///
    /// ✅ Best practices:
    /// 1. Always include proof for external encrypted inputs
    /// 2. Generate fresh proof for each transaction
    /// 3. Batch multiple values in one proof when possible
    /// 4. Ensure correct address binding (contract + user)
    ///
    /// @custom:concept Common mistakes
    function commonMistakes() external pure returns (string memory) {
        return "Forgetting proof, reusing proofs, wrong address binding";
    }

    /// @notice Retrieves stored secret
    /// @return The encrypted secret value
    /// @dev Returns handle for client-side decryption
    function getMySecret() external view returns (euint32) {
        return userSecrets[msg.sender];
    }
}
