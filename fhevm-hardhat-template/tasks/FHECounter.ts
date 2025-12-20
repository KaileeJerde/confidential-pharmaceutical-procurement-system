import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

task("get-count", "Gets the current counter value")
  .addParam("contract", "The contract address")
  .setAction(async function (taskArguments: TaskArguments, hre) {
    const { contract } = taskArguments;

    const FHECounter = await hre.ethers.getContractAt("FHECounter", contract);
    const count = await FHECounter.getCount();

    console.log(`Current count: ${count}`);
  });
