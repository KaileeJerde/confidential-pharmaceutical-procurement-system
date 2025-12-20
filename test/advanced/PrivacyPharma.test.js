const { expect } = require("chai");
const { ethers } = require("hardhat");

/**
 * @title PrivacyPharma Test Suite
 * @notice Comprehensive test suite for the PrivacyPharma contract
 * @dev Demonstrates FHEVM concepts: encryption, access control, and private computation
 *
 * ## Key FHEVM Concepts Tested:
 * - Encrypted data storage using euint32 and euint64
 * - Access control with FHE.allow() and FHE.allowThis()
 * - Private computations with FHE.add, FHE.sub, FHE.lt, FHE.le, FHE.ge
 * - Supplier matching using encrypted values
 * - Decryption workflow for revealing order details
 *
 * @chapter access-control
 * @chapter encryption
 * @chapter private-computation
 */
describe("PrivacyPharma", function () {
  let privacyPharma;
  let owner;
  let buyer;
  let supplier1;
  let supplier2;
  let supplier3;

  /**
   * @notice Deploy fresh contract instance before each test
   * @dev Ensures isolated test environment
   */
  beforeEach(async function () {
    [owner, buyer, supplier1, supplier2, supplier3] = await ethers.getSigners();

    const PrivacyPharma = await ethers.getContractFactory("PrivacyPharma");
    privacyPharma = await PrivacyPharma.deploy();
    await privacyPharma.deployed();
  });

  /**
   * @section Deployment Tests
   * @notice Verify contract initialization
   */
  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      expect(await privacyPharma.owner()).to.equal(owner.address);
    });

    it("Should initialize with order ID of 1", async function () {
      expect(await privacyPharma.getCurrentOrderId()).to.equal(1);
    });

    it("Should set the deployment timestamp", async function () {
      const lastOrderTime = await privacyPharma.lastOrderTime();
      expect(lastOrderTime).to.be.gt(0);
    });
  });

  /**
   * @section Supplier Verification Tests
   * @notice Test access control for supplier verification
   * @dev Demonstrates owner-only access control pattern
   */
  describe("Supplier Verification", function () {
    it("Should allow owner to verify suppliers", async function () {
      await expect(privacyPharma.verifySupplier(supplier1.address))
        .to.emit(privacyPharma, "SupplierVerified")
        .withArgs(supplier1.address);

      expect(await privacyPharma.isVerifiedSupplier(supplier1.address)).to.be.true;
    });

    it("Should reject non-owner verification attempts", async function () {
      await expect(
        privacyPharma.connect(buyer).verifySupplier(supplier1.address)
      ).to.be.revertedWith("Not authorized");
    });

    it("Should initialize supplier reputation on verification", async function () {
      await privacyPharma.verifySupplier(supplier1.address);
      // Reputation is encrypted, so we can only verify the supplier is verified
      expect(await privacyPharma.isVerifiedSupplier(supplier1.address)).to.be.true;
    });

    it("Should allow multiple suppliers to be verified", async function () {
      await privacyPharma.verifySupplier(supplier1.address);
      await privacyPharma.verifySupplier(supplier2.address);
      await privacyPharma.verifySupplier(supplier3.address);

      expect(await privacyPharma.isVerifiedSupplier(supplier1.address)).to.be.true;
      expect(await privacyPharma.isVerifiedSupplier(supplier2.address)).to.be.true;
      expect(await privacyPharma.isVerifiedSupplier(supplier3.address)).to.be.true;
    });
  });

  /**
   * @section Order Creation Tests
   * @notice Test encrypted order creation functionality
   * @dev Demonstrates FHE encryption of sensitive data (drugId, quantity, budget)
   * @chapter encryption
   */
  describe("Order Creation", function () {
    it("Should create an order with encrypted details", async function () {
      const drugId = 12345;
      const quantity = 100;
      const maxBudget = 50000;

      await expect(
        privacyPharma.connect(buyer).createOrder(drugId, quantity, maxBudget)
      )
        .to.emit(privacyPharma, "OrderCreated")
        .withArgs(1, buyer.address, await ethers.provider.getBlock("latest").then(b => b.timestamp + 1));

      const orderInfo = await privacyPharma.getOrderInfo(1);
      expect(orderInfo.orderActive).to.be.true;
      expect(orderInfo.orderFulfilled).to.be.false;
      expect(orderInfo.buyer).to.equal(buyer.address);
    });

    it("Should reject orders with invalid drug ID", async function () {
      await expect(
        privacyPharma.connect(buyer).createOrder(0, 100, 50000)
      ).to.be.revertedWith("Invalid drug ID");
    });

    it("Should reject orders with invalid quantity", async function () {
      await expect(
        privacyPharma.connect(buyer).createOrder(12345, 0, 50000)
      ).to.be.revertedWith("Invalid quantity");
    });

    it("Should reject orders with invalid budget", async function () {
      await expect(
        privacyPharma.connect(buyer).createOrder(12345, 100, 0)
      ).to.be.revertedWith("Invalid budget");
    });

    it("Should increment order ID after creation", async function () {
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);
      expect(await privacyPharma.getCurrentOrderId()).to.equal(2);

      await privacyPharma.connect(buyer).createOrder(67890, 200, 100000);
      expect(await privacyPharma.getCurrentOrderId()).to.equal(3);
    });

    it("Should allow multiple buyers to create orders", async function () {
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);
      await privacyPharma.connect(supplier1).createOrder(67890, 200, 100000);

      const order1 = await privacyPharma.getOrderInfo(1);
      const order2 = await privacyPharma.getOrderInfo(2);

      expect(order1.buyer).to.equal(buyer.address);
      expect(order2.buyer).to.equal(supplier1.address);
    });
  });

  /**
   * @section Bid Submission Tests
   * @notice Test encrypted bid submission and access control
   * @dev Demonstrates supplier verification requirement and encrypted bid data
   * @chapter access-control
   * @chapter encryption
   */
  describe("Bid Submission", function () {
    beforeEach(async function () {
      // Create an order first
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);
      // Verify supplier
      await privacyPharma.verifySupplier(supplier1.address);
    });

    it("Should allow verified suppliers to submit bids", async function () {
      await expect(
        privacyPharma.connect(supplier1).submitBid(1, 45000, 150)
      )
        .to.emit(privacyPharma, "BidSubmitted")
        .withArgs(supplier1.address, 1);

      const bidStatus = await privacyPharma.getBidStatus(1, supplier1.address);
      expect(bidStatus.hasBid).to.be.true;
    });

    it("Should reject bids from unverified suppliers", async function () {
      await expect(
        privacyPharma.connect(supplier2).submitBid(1, 45000, 150)
      ).to.be.revertedWith("Not verified supplier");
    });

    it("Should reject bids on inactive orders", async function () {
      await expect(
        privacyPharma.connect(supplier1).submitBid(999, 45000, 150)
      ).to.be.revertedWith("Order not active");
    });

    it("Should reject duplicate bids from same supplier", async function () {
      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150);

      await expect(
        privacyPharma.connect(supplier1).submitBid(1, 40000, 150)
      ).to.be.revertedWith("Already submitted bid");
    });

    it("Should reject bids with invalid price", async function () {
      await expect(
        privacyPharma.connect(supplier1).submitBid(1, 0, 150)
      ).to.be.revertedWith("Invalid price");
    });

    it("Should reject bids with invalid quantity", async function () {
      await expect(
        privacyPharma.connect(supplier1).submitBid(1, 45000, 0)
      ).to.be.revertedWith("Invalid quantity");
    });

    it("Should allow multiple suppliers to bid on same order", async function () {
      await privacyPharma.verifySupplier(supplier2.address);

      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150);
      await privacyPharma.connect(supplier2).submitBid(1, 48000, 120);

      const bid1 = await privacyPharma.getBidStatus(1, supplier1.address);
      const bid2 = await privacyPharma.getBidStatus(1, supplier2.address);

      expect(bid1.hasBid).to.be.true;
      expect(bid2.hasBid).to.be.true;
    });

    it("Should track interested suppliers", async function () {
      await privacyPharma.verifySupplier(supplier2.address);
      await privacyPharma.verifySupplier(supplier3.address);

      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150);
      await privacyPharma.connect(supplier2).submitBid(1, 48000, 120);
      await privacyPharma.connect(supplier3).submitBid(1, 46000, 200);

      const orderInfo = await privacyPharma.getOrderInfo(1);
      expect(orderInfo.supplierCount).to.equal(3);
    });
  });

  /**
   * @section Order Matching Tests
   * @notice Test private computation for supplier selection
   * @dev Demonstrates FHE computations (comparison, selection) on encrypted data
   * @chapter private-computation
   */
  describe("Order Matching", function () {
    beforeEach(async function () {
      // Create order
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);

      // Verify suppliers
      await privacyPharma.verifySupplier(supplier1.address);
      await privacyPharma.verifySupplier(supplier2.address);
      await privacyPharma.verifySupplier(supplier3.address);

      // Submit bids
      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150); // Best price, can fulfill
      await privacyPharma.connect(supplier2).submitBid(1, 48000, 120); // Higher price
      await privacyPharma.connect(supplier3).submitBid(1, 46000, 200); // Medium price
    });

    it("Should allow buyer to match their order", async function () {
      await expect(privacyPharma.connect(buyer).matchOrder(1))
        .to.emit(privacyPharma, "OrderMatched");

      const orderInfo = await privacyPharma.getOrderInfo(1);
      expect(orderInfo.orderActive).to.be.false;
      expect(orderInfo.supplier).to.not.equal(ethers.constants.AddressZero);
    });

    it("Should reject matching by non-buyer", async function () {
      await expect(
        privacyPharma.connect(supplier1).matchOrder(1)
      ).to.be.revertedWith("Not order owner");
    });

    it("Should reject matching order with no bids", async function () {
      await privacyPharma.connect(buyer).createOrder(67890, 200, 100000);

      await expect(
        privacyPharma.connect(buyer).matchOrder(2)
      ).to.be.revertedWith("No bids available");
    });

    it("Should reject matching inactive order", async function () {
      await privacyPharma.connect(buyer).matchOrder(1);

      await expect(
        privacyPharma.connect(buyer).matchOrder(1)
      ).to.be.revertedWith("Order not active");
    });

    it("Should mark selected supplier as qualified", async function () {
      await privacyPharma.connect(buyer).matchOrder(1);

      const orderInfo = await privacyPharma.getOrderInfo(1);
      const selectedSupplier = orderInfo.supplier;

      const bidStatus = await privacyPharma.getBidStatus(1, selectedSupplier);
      expect(bidStatus.qualified).to.be.true;
    });
  });

  /**
   * @section Order Fulfillment Tests
   * @notice Test decryption workflow and order completion
   * @dev Demonstrates async decryption and revealing encrypted data
   * @chapter public-decryption
   */
  describe("Order Fulfillment", function () {
    beforeEach(async function () {
      // Create order, verify suppliers, submit bids, and match
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);
      await privacyPharma.verifySupplier(supplier1.address);
      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150);
      await privacyPharma.connect(buyer).matchOrder(1);
    });

    it("Should allow selected supplier to initiate fulfillment", async function () {
      const orderInfo = await privacyPharma.getOrderInfo(1);
      const selectedSupplier = orderInfo.supplier;

      // Get the signer for the selected supplier
      const supplierSigner = await ethers.getSigner(selectedSupplier);

      await expect(
        privacyPharma.connect(supplierSigner).fulfillOrder(1)
      ).to.not.be.reverted;
    });

    it("Should reject fulfillment by non-selected supplier", async function () {
      await expect(
        privacyPharma.connect(supplier2).fulfillOrder(1)
      ).to.be.revertedWith("Not selected supplier");
    });

    it("Should reject fulfillment of already fulfilled order", async function () {
      const orderInfo = await privacyPharma.getOrderInfo(1);
      const selectedSupplier = orderInfo.supplier;
      const supplierSigner = await ethers.getSigner(selectedSupplier);

      // First fulfillment
      await privacyPharma.connect(supplierSigner).fulfillOrder(1);

      // Attempt second fulfillment
      await expect(
        privacyPharma.connect(supplierSigner).fulfillOrder(1)
      ).to.be.revertedWith("Order already fulfilled");
    });
  });

  /**
   * @section View Functions Tests
   * @notice Test public view functions for order and supplier information
   */
  describe("View Functions", function () {
    beforeEach(async function () {
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);
      await privacyPharma.verifySupplier(supplier1.address);
    });

    it("Should return correct order information", async function () {
      const orderInfo = await privacyPharma.getOrderInfo(1);

      expect(orderInfo.orderActive).to.be.true;
      expect(orderInfo.orderFulfilled).to.be.false;
      expect(orderInfo.buyer).to.equal(buyer.address);
      expect(orderInfo.supplier).to.equal(ethers.constants.AddressZero);
      expect(orderInfo.supplierCount).to.equal(0);
    });

    it("Should return correct supplier verification status", async function () {
      expect(await privacyPharma.isVerifiedSupplier(supplier1.address)).to.be.true;
      expect(await privacyPharma.isVerifiedSupplier(supplier2.address)).to.be.false;
    });

    it("Should return correct bid status", async function () {
      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150);

      const bidStatus = await privacyPharma.getBidStatus(1, supplier1.address);
      expect(bidStatus.hasBid).to.be.true;
      expect(bidStatus.qualified).to.be.false;
    });

    it("Should return current order ID", async function () {
      expect(await privacyPharma.getCurrentOrderId()).to.equal(2);
    });

    it("Should reject viewing fulfilled order details before fulfillment", async function () {
      await expect(
        privacyPharma.getFulfilledOrderDetails(1)
      ).to.be.revertedWith("Order not fulfilled yet");
    });
  });

  /**
   * @section Anti-pattern Tests
   * @notice Test common mistakes and edge cases
   * @dev Demonstrates what NOT to do with FHEVM
   * @chapter anti-patterns
   */
  describe("Anti-patterns and Edge Cases", function () {
    it("Should handle zero address supplier verification gracefully", async function () {
      await expect(
        privacyPharma.verifySupplier(ethers.constants.AddressZero)
      ).to.not.be.reverted;
    });

    it("Should handle non-existent order queries", async function () {
      const orderInfo = await privacyPharma.getOrderInfo(999);
      expect(orderInfo.orderActive).to.be.false;
    });

    it("Should handle bid queries for non-existent orders", async function () {
      const bidStatus = await privacyPharma.getBidStatus(999, supplier1.address);
      expect(bidStatus.hasBid).to.be.false;
    });
  });

  /**
   * @section Integration Tests
   * @notice End-to-end workflow tests
   * @dev Complete order lifecycle from creation to fulfillment
   */
  describe("Integration Tests", function () {
    it("Should complete full order lifecycle", async function () {
      // 1. Verify suppliers
      await privacyPharma.verifySupplier(supplier1.address);
      await privacyPharma.verifySupplier(supplier2.address);

      // 2. Create order
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);

      // 3. Submit bids
      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150);
      await privacyPharma.connect(supplier2).submitBid(1, 48000, 120);

      // 4. Match order
      await privacyPharma.connect(buyer).matchOrder(1);

      // 5. Verify matching worked
      const orderInfo = await privacyPharma.getOrderInfo(1);
      expect(orderInfo.orderActive).to.be.false;
      expect(orderInfo.supplier).to.not.equal(ethers.constants.AddressZero);

      // 6. Initiate fulfillment
      const selectedSupplier = orderInfo.supplier;
      const supplierSigner = await ethers.getSigner(selectedSupplier);
      await privacyPharma.connect(supplierSigner).fulfillOrder(1);
    });

    it("Should handle multiple concurrent orders", async function () {
      await privacyPharma.verifySupplier(supplier1.address);
      await privacyPharma.verifySupplier(supplier2.address);

      // Create multiple orders
      await privacyPharma.connect(buyer).createOrder(12345, 100, 50000);
      await privacyPharma.connect(buyer).createOrder(67890, 200, 100000);
      await privacyPharma.connect(buyer).createOrder(11111, 50, 25000);

      // Submit bids on all orders
      await privacyPharma.connect(supplier1).submitBid(1, 45000, 150);
      await privacyPharma.connect(supplier1).submitBid(2, 95000, 250);
      await privacyPharma.connect(supplier2).submitBid(1, 48000, 120);
      await privacyPharma.connect(supplier2).submitBid(3, 23000, 60);

      // Match orders
      await privacyPharma.connect(buyer).matchOrder(1);
      await privacyPharma.connect(buyer).matchOrder(2);

      // Verify both matched correctly
      const order1 = await privacyPharma.getOrderInfo(1);
      const order2 = await privacyPharma.getOrderInfo(2);

      expect(order1.orderActive).to.be.false;
      expect(order2.orderActive).to.be.false;
      expect(order1.supplier).to.not.equal(ethers.constants.AddressZero);
      expect(order2.supplier).to.not.equal(ethers.constants.AddressZero);
    });
  });
});
