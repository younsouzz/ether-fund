const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EtherFund", function () {
  let etherFund;
  let owner;
  let user;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
    const EtherFund = await ethers.getContractFactory("EtherFund");
    etherFund = await EtherFund.deploy();
    await etherFund.waitForDeployment();
  });

  it("should accept funds", async () => {
    await user.sendTransaction({
      to: etherFund.target, // utilise .target en Ethers v6
      value: ethers.parseEther("1.0"),
    });

    const balance = await etherFund.getBalance();
    expect(balance).to.equal(ethers.parseEther("1.0"));
  });

  it("should only allow owner to withdraw", async () => {
    await user.sendTransaction({
      to: etherFund.target,
      value: ethers.parseEther("1.0"),
    });

    await expect(
      etherFund.connect(user).withdraw()
    ).to.be.revertedWith("Only owner can withdraw");

    await expect(etherFund.connect(owner).withdraw()).to.not.be.reverted;
  });
});
