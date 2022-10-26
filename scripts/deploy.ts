import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  if (!deployer) {
    throw new Error("No deployer found");
  }
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  const MonkeyNFT = await ethers.getContractFactory("MonkeyNFT");

  console.log(`Deploying Contract...`);
  const monkeyNft = await MonkeyNFT.deploy();
  await monkeyNft.deployed();
  console.log(`Deployed MonkeyNFT to: ${monkeyNft.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
