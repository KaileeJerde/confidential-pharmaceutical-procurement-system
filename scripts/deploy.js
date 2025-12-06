/**
 * @title PrivacyPharma Deployment Script
 * @notice Deploys the PrivacyPharma contract to the specified network
 * @dev Uses Hardhat deployment framework
 *
 * ## Usage:
 * npx hardhat run scripts/deploy.js --network sepolia
 *
 * ## Requirements:
 * - FHEVM library (@fhevm/solidity) must be installed
 * - Network must support FHE operations (Sepolia testnet)
 * - Deployer wallet must have sufficient ETH for gas
 *
 * @chapter deployment
 */

const hre = require("hardhat");

async function main() {
  console.log("=".repeat(60));
  console.log("PrivacyPharma Deployment");
  console.log("=".repeat(60));

  // Get deployer account
  const [deployer] = await hre.ethers.getSigners();
  console.log("\nDeploying contracts with account:", deployer.address);

  // Check deployer balance
  const balance = await deployer.getBalance();
  console.log("Account balance:", hre.ethers.utils.formatEther(balance), "ETH");

  if (balance.isZero()) {
    throw new Error("Deployer account has no ETH. Please fund the account before deploying.");
  }

  // Get network information
  const network = await hre.ethers.provider.getNetwork();
  console.log("Deploying to network:", network.name, "(chainId:", network.chainId + ")");

  console.log("\n" + "-".repeat(60));
  console.log("Deploying PrivacyPharma contract...");
  console.log("-".repeat(60));

  // Deploy the contract
  const PrivacyPharma = await hre.ethers.getContractFactory("PrivacyPharma");
  const privacyPharma = await PrivacyPharma.deploy();

  console.log("\nWaiting for deployment transaction to be mined...");
  await privacyPharma.deployed();

  console.log("\n✅ PrivacyPharma deployed successfully!");
  console.log("\n" + "=".repeat(60));
  console.log("Deployment Summary");
  console.log("=".repeat(60));
  console.log("Contract Address:", privacyPharma.address);
  console.log("Deployer (Owner):", deployer.address);
  console.log("Network:", network.name);
  console.log("Chain ID:", network.chainId);
  console.log("Transaction Hash:", privacyPharma.deployTransaction.hash);
  console.log("Gas Used:", privacyPharma.deployTransaction.gasLimit.toString());
  console.log("=".repeat(60));

  // Wait for additional confirmations on mainnet/testnet
  if (network.chainId !== 31337) { // Not localhost
    console.log("\nWaiting for 5 block confirmations...");
    await privacyPharma.deployTransaction.wait(5);
    console.log("✅ Contract confirmed on blockchain");
  }

  // Verify initial state
  console.log("\n" + "-".repeat(60));
  console.log("Verifying Initial Contract State");
  console.log("-".repeat(60));

  const owner = await privacyPharma.owner();
  const currentOrderId = await privacyPharma.getCurrentOrderId();
  const lastOrderTime = await privacyPharma.lastOrderTime();

  console.log("Owner:", owner);
  console.log("Current Order ID:", currentOrderId.toString());
  console.log("Last Order Time:", new Date(lastOrderTime.toNumber() * 1000).toLocaleString());

  // Save deployment information
  console.log("\n" + "-".repeat(60));
  console.log("Next Steps");
  console.log("-".repeat(60));
  console.log("1. Update the frontend configuration:");
  console.log("   - Edit public/index.html");
  console.log("   - Set CONTRACT_ADDRESS to:", privacyPharma.address);
  console.log("");
  console.log("2. Verify suppliers before they can submit bids:");
  console.log("   - Call verifySupplier(supplierAddress) as contract owner");
  console.log("");
  console.log("3. (Optional) Verify contract on Etherscan:");
  console.log("   npx hardhat verify --network", network.name, privacyPharma.address);
  console.log("=".repeat(60));

  // Save deployment info to file
  const fs = require("fs");
  const deploymentInfo = {
    network: network.name,
    chainId: network.chainId,
    contractAddress: privacyPharma.address,
    deployer: deployer.address,
    deploymentTime: new Date().toISOString(),
    transactionHash: privacyPharma.deployTransaction.hash,
  };

  const deploymentsDir = "./deployments";
  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir);
  }

  const deploymentFile = `${deploymentsDir}/${network.name}-${Date.now()}.json`;
  fs.writeFileSync(deploymentFile, JSON.stringify(deploymentInfo, null, 2));
  console.log("\n📝 Deployment info saved to:", deploymentFile);
}

// Execute deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("\n❌ Deployment failed:");
    console.error(error);
    process.exit(1);
  });
