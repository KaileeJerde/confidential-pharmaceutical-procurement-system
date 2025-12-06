/**
 * @title Supplier Verification Script
 * @notice Verifies a supplier address on the PrivacyPharma contract
 * @dev Admin function to allow suppliers to participate
 *
 * ## Usage:
 * npx hardhat run scripts/verify-supplier.js --network sepolia SUPPLIER_ADDRESS
 *
 * @chapter access-control
 */

const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  // Get contract address from environment or command line
  const contractAddress = process.env.CONTRACT_ADDRESS;
  if (!contractAddress) {
    throw new Error("Please set CONTRACT_ADDRESS environment variable");
  }

  // Get supplier address from command line args
  const supplierAddress = process.argv[2];
  if (!supplierAddress) {
    throw new Error("Please provide supplier address as argument");
  }

  if (!hre.ethers.utils.isAddress(supplierAddress)) {
    throw new Error("Invalid supplier address format");
  }

  console.log("=".repeat(60));
  console.log("Verify Supplier");
  console.log("=".repeat(60));
  console.log("Contract Address:", contractAddress);
  console.log("Supplier Address:", supplierAddress);
  console.log("Verifier (Owner):", deployer.address);

  // Connect to contract
  const PrivacyPharma = await hre.ethers.getContractFactory("PrivacyPharma");
  const privacyPharma = PrivacyPharma.attach(contractAddress);

  // Check if already verified
  const isVerified = await privacyPharma.isVerifiedSupplier(supplierAddress);
  console.log("\nCurrent Status: Already Verified?", isVerified);

  // Verify supplier
  if (!isVerified) {
    console.log("\nVerifying supplier...");
    const tx = await privacyPharma.verifySupplier(supplierAddress);
    console.log("Transaction Hash:", tx.hash);

    console.log("Waiting for confirmation...");
    await tx.wait();
    console.log("✅ Supplier verified successfully!");
  } else {
    console.log("ℹ️  Supplier is already verified");
  }

  // Confirm verification
  const finalStatus = await privacyPharma.isVerifiedSupplier(supplierAddress);
  console.log("\nFinal Status: Verified?", finalStatus);
  console.log("=".repeat(60));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error:", error.message);
    process.exit(1);
  });
