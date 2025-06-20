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
    await etherFund.deployed();
  });

  it("should accept funds", async () => {
    await user.sendTransaction({
      to: etherFund.address,
      value: ethers.utils.parseEther("1.0"),
    });

    const balance = await etherFund.getBalance();
    expect(balance).to.equal(ethers.utils.parseEther("1.0"));
  });

  it("should only allow owner to withdraw", async () => {
    await user.sendTransaction({
      to: etherFund.address,
      value: ethers.utils.parseEther("1.0"),
    });

    await expect(
      etherFund.connect(user).withdraw()
    ).to.be.revertedWith("Only owner can withdraw");

    await expect(etherFund.connect(owner).withdraw()).to.not.be.reverted;
  });
});
