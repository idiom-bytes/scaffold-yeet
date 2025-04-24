import { expect } from "chai";
import { ethers } from "hardhat";
import { Greeting } from "../typechain-types";

describe("Greeting", function () {
  // We define a fixture to reuse the same setup in every test.

  let greetingContract: Greeting;
  before(async () => {
    const [owner] = await ethers.getSigners();
    const greetingContractFactory = await ethers.getContractFactory("Greeting");
    greetingContract = (await greetingContractFactory.deploy(owner.address)) as Greeting;
    await greetingContract.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should have the right message on deploy", async function () {
      expect(await greetingContract.greeting()).to.equal("Building Unstoppable Apps!!!");
    });

    it("Should allow setting a new message", async function () {
      const newGreeting = "Learn Scaffold-ETH 2! :)";

      await greetingContract.setGreeting(newGreeting);
      expect(await greetingContract.greeting()).to.equal(newGreeting);
    });
  });
});
