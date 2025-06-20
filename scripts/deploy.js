const hre = require("hardhat");

async function main() {
  const EtherFund = await hre.ethers.getContractFactory("EtherFund");
  const etherFund = await EtherFund.deploy();
  await etherFund.deployed();

  console.log(`EtherFund deployed to: ${etherFund.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
