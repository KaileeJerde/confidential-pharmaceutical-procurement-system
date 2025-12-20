// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity ^0.8.24;

import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Access Control Example
/// @notice Comprehensive demonstration of FHE access control patterns
/// @dev Shows FHE.allow, FHE.allowThis, FHE.allowTransient and permission management
/// @custom:category basic
/// @custom:chapter access-control, permissions
contract AccessControlExample is ZamaEthereumConfig {
    address public owner;

    mapping(address => euint32) private userBalances;
    mapping(address => mapping(address => bool)) private approvals;

    event BalanceStored(address indexed user);
    event PermissionGranted(address indexed from, address indexed to);
    event TransientPermissionUsed(address indexed user);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Stores a balance with standard permissions
    /// @param inputBalance The encrypted balance
    /// @param inputProof Zero-knowledge proof
    /// @dev Demonstrates FHE.allowThis and FHE.allow
    /// @custom:pattern Standard permission grant
    function storeBalance(
        externalEuint32 inputBalance,
        bytes calldata inputProof
    ) external {
        euint32 balance = FHE.fromExternal(inputBalance, inputProof);

        userBalances[msg.sender] = balance;

        // ✅ STEP 1: Grant contract permission to use the encrypted value
        // This allows the contract to perform FHE operations on the value
        FHE.allowThis(balance);

        // ✅ STEP 2: Grant user permission to decrypt their own value
        // This allows msg.sender to decrypt the value client-side
        FHE.allow(balance, msg.sender);

        emit BalanceStored(msg.sender);
    }

    /// @notice Approves another user to view your balance
    /// @param spender The address to grant permission to
    /// @dev Demonstrates granting permission to third parties
    /// @custom:pattern Sharing encrypted data with specific addresses
    function approveBalanceView(address spender) external {
        euint32 balance = userBalances[msg.sender];
        require(FHE.isInitialized(balance), "No balance stored");

        // Grant spender permission to decrypt the balance
        FHE.allow(balance, spender);
        approvals[msg.sender][spender] = true;

        emit PermissionGranted(msg.sender, spender);
    }

    /// @notice Retrieves your own balance
    /// @return The encrypted balance handle
    /// @dev Only owner can decrypt (permission was granted in storeBalance)
    function getMyBalance() external view returns (euint32) {
        return userBalances[msg.sender];
    }

    /// @notice Retrieves another user's balance (if approved)
    /// @param user The address whose balance to view
    /// @return The encrypted balance handle
    /// @dev Only works if user called approveBalanceView for msg.sender
    function getApprovedBalance(address user) external view returns (euint32) {
        require(approvals[user][msg.sender], "Not approved to view balance");
        return userBalances[user];
    }

    /// @notice Demonstrates FHE.allowTransient for gas-efficient temporary permissions
    /// @param inputValue Encrypted value to process
    /// @param inputProof Zero-knowledge proof
    /// @param processor Address that needs temporary access
    /// @dev Transient permissions are cheaper but don't persist
    /// @custom:pattern Gas-efficient temporary permissions
    function processWithTransientPermission(
        externalEuint32 inputValue,
        bytes calldata inputProof,
        address processor
    ) external {
        euint32 value = FHE.fromExternal(inputValue, inputProof);

        // Grant contract permission (standard)
        FHE.allowThis(value);

        // ✅ Use allowTransient for temporary, gas-efficient permission
        // This permission is cheaper but doesn't persist across transactions
        FHE.allowTransient(value, processor);

        emit TransientPermissionUsed(processor);

        // Note: processor can use this permission within this transaction
        // but it won't persist to future transactions
    }

    /// @notice Demonstrates permission requirement for FHE operations
    /// @param user1 First user address
    /// @param user2 Second user address
    /// @return The sum of both balances
    /// @dev Shows that contract needs allowThis to perform operations
    /// @custom:pattern Contract operations require allowThis
    function addBalances(address user1, address user2) external view returns (euint32) {
        euint32 balance1 = userBalances[user1];
        euint32 balance2 = userBalances[user2];

        // This works because storeBalance() called FHE.allowThis
        // Without allowThis, this operation would fail
        euint32 sum = FHE.add(balance1, balance2);

        return sum;
    }

    /// @notice Example showing multiple permission grants
    /// @param inputValue Encrypted value
    /// @param inputProof Zero-knowledge proof
    /// @param viewers Array of addresses to grant permission to
    /// @dev Shows how to grant permissions to multiple addresses
    /// @custom:pattern Bulk permission grants
    function storeAndShareWithMultiple(
        externalEuint32 inputValue,
        bytes calldata inputProof,
        address[] calldata viewers
    ) external {
        euint32 value = FHE.fromExternal(inputValue, inputProof);

        userBalances[msg.sender] = value;

        // Grant contract permission
        FHE.allowThis(value);

        // Grant owner permission
        FHE.allow(value, msg.sender);

        // Grant permission to all viewers
        for (uint i = 0; i < viewers.length; i++) {
            FHE.allow(value, viewers[i]);
            approvals[msg.sender][viewers[i]] = true;
        }

        emit BalanceStored(msg.sender);
    }

    /// @notice ❌ ANTI-PATTERN: Missing allowThis
    /// @param inputValue Encrypted value
    /// @param inputProof Zero-knowledge proof
    /// @dev This demonstrates WRONG permission pattern
    /// @custom:antipattern Missing FHE.allowThis permission
    function storeBalanceWrong(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        euint32 balance = FHE.fromExternal(inputValue, inputProof);

        userBalances[msg.sender] = balance;

        // ❌ WRONG: Missing FHE.allowThis(balance)
        // Contract won't be able to use this value in operations
        // Only granting user permission is insufficient
        FHE.allow(balance, msg.sender);

        // Future operations like addBalances() will FAIL for this value
    }

    /// @notice ✅ CORRECT: Proper permission order
    /// @param inputValue Encrypted value
    /// @param inputProof Zero-knowledge proof
    /// @dev This demonstrates CORRECT permission pattern
    /// @custom:pattern Correct permission grant order
    function storeBalanceCorrect(
        externalEuint32 inputValue,
        bytes calldata inputProof
    ) external {
        euint32 balance = FHE.fromExternal(inputValue, inputProof);

        userBalances[msg.sender] = balance;

        // ✅ CORRECT ORDER:
        // 1. First grant contract permission
        FHE.allowThis(balance);

        // 2. Then grant user permissions
        FHE.allow(balance, msg.sender);

        emit BalanceStored(msg.sender);
    }

    /// @notice Demonstrates conditional permission grants
    /// @param inputValue Encrypted value
    /// @param inputProof Zero-knowledge proof
    /// @param shouldShareWithOwner Whether to share with contract owner
    /// @dev Shows conditional permission based on business logic
    /// @custom:pattern Conditional permissions
    function storeWithConditionalSharing(
        externalEuint32 inputValue,
        bytes calldata inputProof,
        bool shouldShareWithOwner
    ) external {
        euint32 value = FHE.fromExternal(inputValue, inputProof);

        userBalances[msg.sender] = value;

        // Always grant these permissions
        FHE.allowThis(value);
        FHE.allow(value, msg.sender);

        // Conditionally share with owner
        if (shouldShareWithOwner && msg.sender != owner) {
            FHE.allow(value, owner);
        }

        emit BalanceStored(msg.sender);
    }

    /// @notice Revokes approval for a spender
    /// @param spender The address to revoke permission from
    /// @dev Note: Cannot revoke FHE.allow after granted (by design)
    /// This only revokes logical approval, not FHE permission
    function revokeApproval(address spender) external {
        approvals[msg.sender][spender] = false;
    }

    /// @notice Checks if an address is approved to view another's balance
    /// @param user The balance owner
    /// @param spender The address to check
    /// @return True if approved, false otherwise
    function isApproved(address user, address spender) external view returns (bool) {
        return approvals[user][spender];
    }
}
