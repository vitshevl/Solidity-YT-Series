const hre = require('hardhat')
const ethers = hre.ethers

async function main() {
  const [signer] = await ethers.getSigners()

  const Erc = await ethers.getContractFactory("EPAMShop", signer)
  const erc = await Erc.deploy()
  await erc.waitForDeployment()
  console.log(await erc.getAddress())
  console.log(await erc.token())
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });