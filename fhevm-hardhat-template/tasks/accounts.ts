import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

task("accounts", "Prints the list of accounts", async (_taskArgs: TaskArguments, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});
