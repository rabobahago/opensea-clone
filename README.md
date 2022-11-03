# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help



Full stack NFT marketplace built with Goerli, Solidity, IPFS, & Next.js
Header

This is the codebase to go along with tbe blog post Building a Full Stack NFT Marketplace on Ethereum with Polygon

Running this project
Gitpod
To deploy this project to Gitpod, follow these steps:

Click this link to deploy
Open in Gitpod

Import the RPC address given to you by GitPod into your MetaMask wallet
This endpoint will look something like this:

https://8545-copper-swordtail-j1mvhxv3.ws-eu18.gitpod.io/
The chain ID should be 1337. If you have a localhost rpc set up, you may need to overwrite it.

Local setup
To run this project locally, follow these steps.

Clone the project locally, change into the directory, and install the dependencies:
git clone https://github.com/rabobahago/opensea-clone.git

cd opensea-clone

# install using NPM or Yarn
npm install

# or

yarn
Start the local Hardhat node
npx hardhat node
With the network running, deploy the contracts to the local network in a separate terminal window
npx hardhat run scripts/deploy.js --network localhost
Start the app
npm run dev
Configuration
To deploy to goerli test networks, update the configurations located in hardhat.config.js to use a private key and, optionally, deploy to a private RPC like Infura.

require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
const { PRIVATE_KEY, PROJECT_PRIVATE_KEY } = process.env;
const API_URL = "https://eth-goerli.g.alchemy.com/v2";
module.exports = {
  solidity: "0.8.4",
  defaultNetwork: "goerli",
  networks: {
    hardhat: {
      chainId: 1337,
    },
    goerli: {
      url: `${API_URL}/${PROJECT_PRIVATE_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
};


If using alchemy, update alchemyid with your alchemy project ID.
```

