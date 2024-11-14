// backend/scripts/deploy.js

const { ethers } = require("hardhat");

async function main() {
    const DonationContract = await ethers.getContractFactory("DonationContract");
    const donationContract = await DonationContract.deploy();
    await donationContract.deployed();
    console.log("DonationContract deployed to:", donationContract.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
