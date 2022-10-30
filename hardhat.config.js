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
