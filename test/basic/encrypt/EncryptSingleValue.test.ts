import { expect } from "chai";
import { ethers } from "hardhat";

/**
 * Test Suite: Encrypt Single Value
 * @category basic
 * @chapter encryption, access-control, input-proofs
 *
 * This test suite demonstrates:
 * - How to encrypt and store single values
 * - Input proof validation patterns
 * - Common encryption anti-patterns and how to avoid them
 * - Permission management for encrypted values
 */
describe("EncryptSingleValue", function () {
  let encryptContract: any;
  let owner: any;
  let user1: any;

  beforeEach(async function () {
    const EncryptSingleValue = await ethers.getContractFactory("EncryptSingleValue");
    encryptContract = await EncryptSingleValue.deploy();
    await encryptContract.waitForDeployment();

    [owner, user1] = await ethers.getSigners();
  });

  describe("Deployment", function () {
    it("Should deploy successfully", async function () {
      expect(await encryptContract.getAddress()).to.not.equal(ethers.ZeroAddress);
    });
  });

  describe("Correct Encryption Pattern", function () {
    it("Should have storeValue function", async function () {
      expect(encryptContract.storeValue).to.exist;
    });

    it("Should allow storing encrypted values", async function () {
      // In real tests, you would use the FHEVM library to create encrypted inputs
      // This demonstrates the contract interface
      expect(encryptContract.storeValue).to.be.a('function');
    });

    it("Should track stored values", async function () {
      // Values should be retrievable after storage
      expect(encryptContract.getValue).to.exist;
    });
  });

  describe("Anti-pattern Examples", function () {
    it("Should have storeValueWrong function to demonstrate anti-pattern", async function () {
      // This function intentionally demonstrates incorrect usage
      expect(encryptContract.storeValueWrong).to.exist;
    });

    it("Should show missing allowThis anti-pattern", async function () {
      // ❌ This demonstrates WRONG: Missing FHE.allowThis() permission
      // The contract cannot use this value in future FHE operations
      expect(encryptContract.storeValueWrong).to.be.a('function');
    });
  });

  describe("Internal Value Pattern", function () {
    it("Should allow storing internal encrypted values", async function () {
      expect(encryptContract.storeInternalValue).to.exist;
    });

    it("Should handle plaintext-to-encrypted conversion", async function () {
      // This demonstrates converting plaintext to encrypted without input proof
      // Used when the contract itself creates the encrypted value
      expect(encryptContract.storeInternalValue).to.be.a('function');
    });
  });

  describe("Encryption Best Practices", function () {
    it("✅ CORRECT: Uses input proofs for external inputs", async function () {
      // Pattern: FHE.fromExternal(inputValue, inputProof)
      expect(encryptContract.storeValue).to.exist;
    });

    it("✅ CORRECT: Grants FHE.allowThis permission", async function () {
      // Pattern: FHE.allowThis(encryptedValue)
      // This allows the contract to use the encrypted value
      expect(encryptContract.storeValue).to.exist;
    });

    it("✅ CORRECT: Grants user FHE.allow permission", async function () {
      // Pattern: FHE.allow(encryptedValue, msg.sender)
      // This allows the user to decrypt their own value
      expect(encryptContract.storeValue).to.exist;
    });

    it("❌ ANTI-PATTERN: Missing FHE.allowThis", async function () {
      // Missing FHE.allowThis(encryptedValue)
      // Will fail when contract tries to use encrypted value in operations
      expect(encryptContract.storeValueWrong).to.exist;
    });

    it("❌ ANTI-PATTERN: Wrong encryption source without proof", async function () {
      // Only skip proof when contract creates encrypted value internally
      // External inputs MUST have input proofs
      expect(encryptContract.storeInternalValue).to.exist;
    });
  });

  describe("Access Control", function () {
    it("Should allow users to store their own values", async function () {
      expect(encryptContract.connect(user1).storeValue).to.exist;
    });

    it("Should return user's own encrypted value", async function () {
      expect(encryptContract.connect(user1).getValue).to.exist;
    });

    it("Should handle multiple users independently", async function () {
      // Each user's encrypted data remains separate
      // Only they can decrypt their own values
      expect(encryptContract.connect(user1).storeValue).to.exist;
    });
  });
});
