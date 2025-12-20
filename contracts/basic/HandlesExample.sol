// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, euint64, ebool, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Handles Example
/// @notice Explains what handles are and how they work in FHEVM
/// @dev Demonstrates handle lifecycle, storage, and operations
/// @custom:category basic
/// @custom:chapter handles, encryption
contract HandlesExample is ZamaEthereumConfig {
    // These variables store "handles" to encrypted values
    euint32 public counter;           // Handle to encrypted 32-bit uint
    euint64 public balance;           // Handle to encrypted 64-bit uint
    ebool public flag;                // Handle to encrypted boolean

    mapping(address => euint32) public userHandles;  // Mapping stores handles

    event HandleCreated(address indexed user, string handleType);
    event HandleOperation(string operation);

    /// @notice What are handles?
    /// @dev In FHEVM, encrypted values are NOT stored directly in contract storage.
    /// Instead, contracts store "handles" - references to encrypted values.
    ///
    /// Think of handles like:
    /// - Pointers to encrypted data
    /// - Database primary keys for encrypted values
    /// - File descriptors for encrypted files
    ///
    /// The actual encrypted data is managed by the FHE coprocessor.
    /// Contracts only hold lightweight references (handles).
    ///
    /// @custom:concept What are handles
    function whatAreHandles() external pure returns (string memory) {
        return "Handles are references to encrypted values, not the values themselves";
    }

    /// @notice Handle creation demonstration
    /// @dev Shows different ways to create handles
    /// @custom:pattern Handle creation
    function demonstrateHandleCreation() external {
        // Method 1: Create from plaintext (contract knows the value)
        euint32 handle1 = FHE.asEuint32(42);

        // Method 2: Would be from external input (user knows the value)
        // euint32 handle2 = FHE.fromExternal(externalValue, proof);

        // Method 3: Create from FHE operation result
        euint32 handle3 = FHE.add(handle1, FHE.asEuint32(10));

        // All three are handles pointing to different encrypted values
        emit HandleCreated(msg.sender, "creation");
    }

    /// @notice Handle storage in state variables
    /// @dev Demonstrates how handles are stored
    /// @custom:pattern Handle storage
    function storeHandle(externalEuint32 inputValue, bytes calldata inputProof) external {
        // Create a handle from user input
        euint32 handle = FHE.fromExternal(inputValue, inputProof);

        // Store the handle in contract storage
        // This stores a reference, not the encrypted value itself
        userHandles[msg.sender] = handle;

        // Grant permissions to use this handle
        FHE.allowThis(handle);
        FHE.allow(handle, msg.sender);

        emit HandleCreated(msg.sender, "storage");
    }

    /// @notice Handle operations
    /// @dev Shows that FHE operations consume handles and produce new handles
    /// @custom:pattern Handle operations
    function performHandleOperations(
        externalEuint32 inputA,
        externalEuint32 inputB,
        bytes calldata inputProof
    ) external returns (euint32) {
        // Create handles from inputs
        euint32 handleA = FHE.fromExternal(inputA, inputProof);
        euint32 handleB = FHE.fromExternal(inputB, inputProof);

        // FHE operations take handles as input and return NEW handles
        euint32 sumHandle = FHE.add(handleA, handleB);      // New handle
        euint32 productHandle = FHE.mul(handleA, handleB);  // Another new handle
        euint32 resultHandle = FHE.add(sumHandle, productHandle); // Final handle

        // Each operation creates a new handle to a new encrypted value
        FHE.allowThis(resultHandle);
        FHE.allow(resultHandle, msg.sender);

        emit HandleOperation("arithmetic");

        return resultHandle;  // Return the handle
    }

    /// @notice Handle permissions
    /// @dev Explains how permissions work with handles
    /// @custom:concept Handle permissions
    ///
    /// Permissions are attached to HANDLES, not to plaintext values:
    /// - FHE.allowThis(handle) - Contract can use this handle in operations
    /// - FHE.allow(handle, user) - User can decrypt value referenced by handle
    ///
    /// When you create a NEW handle from an operation, you need to
    /// grant permissions to the new handle separately.
    function demonstrateHandlePermissions(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        // Create initial handle
        euint32 handle1 = FHE.fromExternal(inputValue, inputProof);

        // Grant permissions to handle1
        FHE.allowThis(handle1);
        FHE.allow(handle1, msg.sender);

        // Create new handle from operation
        euint32 handle2 = FHE.add(handle1, FHE.asEuint32(10));

        // IMPORTANT: handle2 is a NEW handle, needs NEW permissions
        FHE.allowThis(handle2);  // Must grant permission to new handle
        FHE.allow(handle2, msg.sender);

        emit HandleOperation("permissions");
    }

    /// @notice Handle lifecycle
    /// @dev Shows the complete lifecycle of a handle
    /// @custom:concept Handle lifecycle
    ///
    /// 1. CREATION: Handle is created (FHE.asEuint32, FHE.fromExternal, etc.)
    /// 2. PERMISSION: Permissions granted (FHE.allowThis, FHE.allow)
    /// 3. STORAGE: Handle stored in contract state
    /// 4. OPERATIONS: Handle used in FHE operations (creates new handles)
    /// 5. RETRIEVAL: Handle retrieved from storage
    /// 6. DECRYPTION: Handle converted to plaintext (if permissions allow)
    function handleLifecycle(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external returns (euint32) {
        // 1. CREATION
        euint32 handle = FHE.fromExternal(inputValue, inputProof);

        // 2. PERMISSION
        FHE.allowThis(handle);
        FHE.allow(handle, msg.sender);

        // 3. STORAGE
        userHandles[msg.sender] = handle;

        // 4. OPERATIONS (creates new handle)
        euint32 newHandle = FHE.add(handle, FHE.asEuint32(1));
        FHE.allowThis(newHandle);
        FHE.allow(newHandle, msg.sender);

        // 5. RETRIEVAL (happens in another function call)
        // 6. DECRYPTION (happens client-side)

        return newHandle;
    }

    /// @notice Handle comparison with plaintext values
    /// @dev Shows how handles differ from regular Solidity types
    /// @custom:concept Handles vs plaintext
    function handlesVsPlaintext() external {
        // Regular Solidity: Variables hold actual values
        uint32 regularValue = 42;
        uint32 sum = regularValue + 10;  // Direct arithmetic

        // FHEVM: Variables hold handles (references)
        euint32 handleValue = FHE.asEuint32(42);
        // Cannot do: handleValue + 10  // ❌ Won't compile
        euint32 handleSum = FHE.add(handleValue, FHE.asEuint32(10));  // ✅ Must use FHE operations

        // Regular: Can view value directly
        // uint32 view = regularValue;  ✅ Works

        // FHEVM: Cannot view encrypted value, only the handle
        // uint32 view = handleValue;  ❌ Won't work
        // Must decrypt: FHE.requestDecryption() then callback

        emit HandleOperation("comparison");
    }

    /// @notice Handle uniqueness
    /// @dev Each encryption produces a unique handle, even for the same value
    /// @custom:concept Handle uniqueness
    function demonstrateHandleUniqueness() external {
        // Encrypt the same value twice
        euint32 handle1 = FHE.asEuint32(42);
        euint32 handle2 = FHE.asEuint32(42);

        // handle1 and handle2 are DIFFERENT handles
        // They refer to different encrypted ciphertexts
        // Even though both encrypt the value 42

        // Comparing handles directly doesn't make sense
        // Use FHE.eq() to compare encrypted values:
        ebool areEqual = FHE.eq(handle1, handle2);  // This will be true (both are 42)

        emit HandleOperation("uniqueness");
    }

    /// @notice Handle storage cost
    /// @dev Explains gas costs of storing handles
    /// @custom:concept Storage costs
    ///
    /// Storing a handle costs the same as storing a uint256:
    /// - Handles are lightweight references (~32 bytes)
    /// - Much cheaper than storing actual encrypted data
    /// - FHE operations cost extra gas (computational overhead)
    function storageC osts() external pure returns (string memory) {
        return "Handles are lightweight (~32 bytes), but FHE operations cost extra gas";
    }

    /// @notice Retrieving handles
    /// @dev Shows how to retrieve stored handles
    function getMyHandle() external view returns (euint32) {
        // Returns the handle, not the plaintext value
        // Client can decrypt if they have permission
        return userHandles[msg.sender];
    }

    /// @notice Checking if handle is initialized
    /// @dev Shows how to check if a handle exists
    function checkHandleExists(address user) external view returns (bool) {
        euint32 handle = userHandles[user];

        // Check if handle is initialized (not zero)
        return FHE.isInitialized(handle);
    }

    /// @notice Key takeaways about handles
    /// @dev Summary of important concepts
    /// @custom:concept Key takeaways
    ///
    /// ✅ Handles are references, not values
    /// ✅ Each operation creates new handles
    /// ✅ Permissions apply to specific handles
    /// ✅ Handles are lightweight and efficient
    /// ✅ Use FHE operations to work with handles
    /// ✅ Cannot directly view encrypted values
    /// ✅ Decryption requires async process
    function keyTakeaways() external pure returns (string memory) {
        return "Handles are lightweight references to encrypted values managed by FHE coprocessor";
    }
}
