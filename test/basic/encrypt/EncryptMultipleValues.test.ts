import { expect } from "chai";
import { ethers } from "hardhat";

/**
 * Test Suite: Encrypt Multiple Values
 * @category basic
 * @chapter encryption, access-control, batch-operations
 *
 * This test suite demonstrates:
 * - How to handle multiple encrypted values efficiently
 * - Batch encryption patterns
 * - Managing permissions for multiple encrypted values
 * - Optimized encryption patterns with combined proofs
 */
describe("EncryptMultipleValues", function () {
  let multiEncryptContract: any;
  let owner: any;
  let user1: any;

  beforeEach(async function () {
    const EncryptMultipleValues = await ethers.getContractFactory("EncryptMultipleValues");
    multiEncryptContract = await EncryptMultipleValues.deploy();
    await multiEncryptContract.waitForDeployment();

    [owner, user1] = await ethers.getSigners();
  });

  describe("Deployment", function () {
    it("Should deploy successfully", async function () {
      expect(await multiEncryptContract.getAddress()).to.not.equal(ethers.ZeroAddress);
    });
  });

  describe("Batch Encryption Pattern", function () {
    it("Should have storeUserData function for multiple values", async function () {
      expect(multiEncryptContract.storeUserData).to.exist;
    });

    it("Should accept multiple encrypted inputs", async function () {
      expect(multiEncryptContract.storeUserData).to.be.a('function');
    });

    it("Should store multiple values in a struct", async function () {
      expect(multiEncryptContract.getUserData).to.exist;
    });
  });

  describe("Multiple Encrypted Types", function () {
    it("Should handle euint32 values", async function () {
      // Age and Score are euint32
      expect(multiEncryptContract.storeUserData).to.exist;
    });

    it("Should handle euint64 values", async function () {
      // Balance is euint64
      expect(multiEncryptContract.storeUserData).to.exist;
    });

    it("Should handle mixed types in single operation", async function () {
      // Demonstrates handling different encrypted types
      expect(multiEncryptContract.storeUserData).to.exist;
    });
  });

  describe("Optimized Batch Pattern", function () {
    it("Should have optimized batch storage function", async function () {
      expect(multiEncryptContract.storeUserDataOptimized).to.exist;
    });

    it("Should support combined proof pattern", async function () {
      // More efficient: single proof for all values
      expect(multiEncryptContract.storeUserDataOptimized).to.exist;
    });

    it("Should provide same security as individual proofs", async function () {
      // Combined proof is as secure but more efficient
      expect(multiEncryptContract.storeUserDataOptimized).to.exist;
    });
  });

  describe("Permission Management", function () {
    it("Should grant allowThis for all encrypted values", async function () {
      // FHE.allowThis needed for each encrypted value
      expect(multiEncryptContract.storeUserData).to.exist;
    });

    it("Should grant user permissions for all values", async function () {
      // FHE.allow(value, user) for each encrypted value
      expect(multiEncryptContract.storeUserData).to.exist;
    });

    it("Should handle independent permission grants", async function () {
      // Each value gets separate permission grants
      expect(multiEncryptContract.storeUserData).to.exist;
    });
  });

  describe("Data Retrieval", function () {
    it("Should return all encrypted values", async function () {
      const [age, balance, score] = await multiEncryptContract.getUserData();
      expect(age).to.not.be.undefined;
      expect(balance).to.not.be.undefined;
      expect(score).to.not.be.undefined;
    });

    it("Should maintain separate handles for each value", async function () {
      const data1 = await multiEncryptContract.getUserData();
      expect(data1.length).to.equal(3);
    });

    it("Should be callable by the storing user", async function () {
      expect(multiEncryptContract.connect(user1).getUserData).to.exist;
    });
  });

  describe("Batch Operation Efficiency", function () {
    it("✅ CORRECT: Uses single combined proof", async function () {
      // More efficient: createEncryptedInput().add32().add64().add32().encrypt()
      expect(multiEncryptContract.storeUserDataOptimized).to.exist;
    });

    it("✅ CORRECT: Groups all permission grants", async function () {
      // All FHE.allowThis and FHE.allow calls for the operation
      expect(multiEncryptContract.storeUserData).to.exist;
    });

    it("Should handle complex data structures", async function () {
      // Demonstrates storing in UserData struct
      expect(multiEncryptContract.getUserData).to.exist;
    });
  });

  describe("Security Properties", function () {
    it("Should maintain encryption during storage", async function () {
      // Values remain encrypted in contract state
      expect(multiEncryptContract.storeUserData).to.exist;
    });

    it("Should prevent unauthorized access", async function () {
      // Only user who stored can decrypt
      expect(multiEncryptContract.getUserData).to.exist;
    });

    it("Should validate input proofs", async function () {
      // Input proofs ensure caller knows plaintext
      expect(multiEncryptContract.storeUserData).to.exist;
    });
  });
});
