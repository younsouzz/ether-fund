const hre = require("hardhat");

async function main() {
  const EtherFund = await hre.ethers.getContractFactory("EtherFund");
  const etherFund = await EtherFund.deploy();
  await etherFund.waitForDeployment();

  console.log(`EtherFund deployed to: ${etherFund.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
