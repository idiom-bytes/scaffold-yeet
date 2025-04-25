import { expect } from "chai";
import { ethers } from "hardhat";
import { Greetings } from "../typechain-types";

describe("Greetings", function () {
  // We define a fixture to reuse the same setup in every test.

  let greetingsContract: Greetings;
  before(async () => {
    const [owner] = await ethers.getSigners();
    const greetingsContractFactory = await ethers.getContractFactory("Greetings");
    greetingsContract = (await greetingsContractFactory.deploy(owner.address)) as Greetings;
    await greetingsContract.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should have the right message on deploy", async function () {
      expect(await greetingsContract.greeting()).to.equal("Building Unstoppable Apps!!!");
    });

    it("Should allow setting a new message", async function () {
      const newGreeting = "Learn Scaffold-ETH 2! :)";

      await greetingsContract.setGreeting(newGreeting);
      expect(await greetingsContract.greeting()).to.equal(newGreeting);
    });
  });
});
