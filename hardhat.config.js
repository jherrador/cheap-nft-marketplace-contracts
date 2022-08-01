require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  etherscan: {
    apiKey:{
      ropsten: process.env.ETHERSCAN_API_KEY,
      rinkeby: process.env.ETHERSCAN_API_KEY
    }
  },
  networks:{
    ropsten: {
  		url: `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`,
  		accounts: [process.env.PRIVATE_KEY]
  	},

    rinkeby: {
  		url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
  		accounts: [process.env.PRIVATE_KEY]
  	}
  }
};
