
import { ethers } from "hardhat";

const insurer = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";
const reinsurer = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";
const amount = 10000;

async function main() {

  const deploy_contract = await ethers.deployContract("ReinsuranceContract", [insurer, reinsurer, amount]);
  //const deploy_contract = await ethers.deployContract("ParametricInsuranceContract");
  //const deploy_contract = await ethers.deployContract("RiskPoolingContract");

  await deploy_contract.waitForDeployment();

  console.log("InsuranceContract is deployed to : ",await deploy_contract.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
