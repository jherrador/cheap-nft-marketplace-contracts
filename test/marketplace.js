const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
const { ethers } = require('hardhat');
  
  describe("MarketPlace", function () {
    async function deployMarketplace() {
        const NFTMarketplace = await hre.ethers.getContractFactory("NFTMarketplace");
        const nftMarketplace = await NFTMarketplace.deploy();
      
        const contract = await nftMarketplace.deployed();
      
        console.log("Contract Deployed at", contract.address);
        return contract;
    }
    async function deployNft() {
        const SimpleCollectible = await hre.ethers.getContractFactory("SimpleCollectible");
        const simpleCollectible = await SimpleCollectible.deploy();
        
        const contract = await simpleCollectible.deployed();
        const [signer] = await hre.ethers.getSigners();

        console.log("Contract Deployed at", contract.address);
      
        contract.createCollectible(await signer.getAddress(), "https://ipfs.io/ipfs/QmdzBhpibPZTPBPL1DPXnv8AvLoAN5TTDzczWw36RoSkoP")

        return contract;
    }

    async function deployToken() {
      const RatherLabs = await hre.ethers.getContractFactory("RatherLabs");
      const ratherLabs = await RatherLabs.deploy();
    
      const contract = await ratherLabs.deployed();
    
      console.log("Contract Deployed at", contract.address);
      return contract;
    }


    async function setup() {
       const nftContract = await deployNft();
       const marketplaceContract = await deployMarketplace();
       const ratherlabsContract = await deployToken();
        return {nftContract, marketplaceContract, ratherlabsContract};
    }
  
    // describe("Auction", function () {
    //   it("trade only ERC20", async function () {
    //    const {nftContract, marketplaceContract, ratherlabsContract} = await setup();
    //    const [signer, secondary_account] = await hre.ethers.getSigners();
    //    const signerAddress = await signer.getAddress();
    //    const secondaryAccountAddress = await secondary_account.getAddress();

    //     console.log("Signer Address", signerAddress);

    //     //0. Mint tokens for secondary_account
    //     await ratherlabsContract.mint(await secondaryAccountAddress, 10);
    //     //1. Approve All NFTs
    //     await nftContract.setApprovalForAll(marketplaceContract.address, true);
    //     expect(await nftContract.isApprovedForAll(signerAddress, marketplaceContract.address)).to.true;

    //     // //2. Approve ERC20
    //     await ratherlabsContract.connect(secondary_account).approve(marketplaceContract.address, 2);

    //     //3. Trade
    //     await marketplaceContract.createMarketSaleWithoutSignature(nftContract.address, 0,signerAddress, secondaryAccountAddress, 1, ratherlabsContract.address);
    //   });
    
    // });
    describe("Signature", function () {
      it("verify signature", async function () {
        const marketplaceContract = await deployMarketplace();
        const [signer, secondary_account] = await hre.ethers.getSigners();
        const signerAddress = "0x534a06e73147D28969bcAe36f08936aAD358a564";

        const r = "0xd8627fe6a4b8048d44d836bc38e022dabd3e19412edf1eb7f917d81a68184bfc";
        const v =27;
        const s ="0x784c6bddc8fa47c988e78776e05645eb21a12102b2f18616993ec94904bfe187";

        const lol = await marketplaceContract.test();
        console.log(lol);
        // const auction = {
        //   tokenId: 2,
        //   contractAddress: "0xbde6e860d0a32ec37f30562f6c915d2a580ef71d",
        //   ownerAddress: "0x9780Ab2bFC783D90098653B79eEDDf869c272f53",
        //   bidderAddress: "0x534a06e73147D28969bcAe36f08936aAD358a564",
        //   bid: ethers.BigNumber.from("30000000000000000000")
        // }
        // console.log(auction);
        // console.log(r);
        // console.log(v);
        // console.log(s);
        // console.log(signerAddress);
        // await marketplaceContract.verifySignature(auction, signerAddress, r, s, v)
      });
    });
    
  });
  