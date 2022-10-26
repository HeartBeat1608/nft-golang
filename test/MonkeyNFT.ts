import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "../node_modules/@nomiclabs/hardhat-ethers/signers";
import { MonkeyNFT } from "../typechain-types";

describe("MonkeyNFT Contract", () => {
  let contract: MonkeyNFT;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  let baseUri: string;

  beforeEach(async () => {
    const Token = await ethers.getContractFactory("MonkeyNFT");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    contract = await Token.deploy();
    baseUri = "https://hardhat.org/test/";
    await contract.setBaseUri(baseUri);
  });

  it("Should initialize contract", async () => {
    expect(await contract.MAX_MONKEYS()).to.equal(10000);
  });

  it("Should set the right owner", async () => {
    expect(await contract.owner()).to.equal(await owner.address);
  });

  it("Should mint", async () => {
    const price = await contract.getPrice();
    const tokenId = await contract.totalSupply();
    expect(
      await contract.mintMonkeys(1, {
        value: price,
      })
    )
      .to.emit(contract, "Transfer")
      .withArgs(ethers.constants.AddressZero, owner.address, tokenId);
    expect(await contract.tokenURI(tokenId)).to.equal(baseUri + "0");
  });
});
