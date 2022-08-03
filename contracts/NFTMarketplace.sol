// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SignatureVerify.sol";

import "hardhat/console.sol";

contract NFTMarketplace {
    SignatureVerify public signatureVerify;

    event CreateMarketSale(address erc721Address,uint256 tokenId,address sellerAddress,address buyerAddress,uint256 sellAmount,address erc20Address);
    event VerifySignature(bytes32 signature, address signer);

    struct Auction {
        uint256 tokenId;
        address contractAddress;
        address ownerAddress;
        address bidderAddress;
        uint256 bid;
    }

    constructor() {
      uint256 chainId;
      assembly {
          chainId := chainid()
      }
      
      signatureVerify = SignatureVerify(address(this), chainId);
    }
    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function createMarketSale(
      address erc721Address,
      uint256 tokenId,
      address sellerAddress,
      address buyerAddress,
      uint256 sellAmount,
      address erc20Address,
      bytes32 signature,
      bytes32 r,
      bytes32 s,
      uint8 v
    ) public onlyInvolvedUsers(buyerAddress, sellerAddress){
      Auction memory auction;

      auction.tokenId = tokenId;
      auction.contractAddress = erc721Address;
      auction.ownerAddress = sellerAddress;
      auction.bidderAddress = buyerAddress;
      auction.bid = sellAmount;

      require (verifySignature(auction, msg.sender, r, s, v), "NFTMarketplace.createMarketSale: This Address cannot create a market sale");
      emit VerifySignature(signature, msg.sender);

      IERC721(erc721Address).safeTransferFrom(sellerAddress, buyerAddress, tokenId);
      IERC20(erc20Address).transferFrom(buyerAddress, sellerAddress, sellAmount);

      emit CreateMarketSale(erc721Address,tokenId,sellerAddress,buyerAddress,sellAmount,erc20Address);
    }

    function verifySignature(Auction memory auction, address signer, bytes32 r, bytes32 s, uint8 v) public view returns(bool) {
      console.log("HOLA");
      console.log(auction.tokenId);
      console.log(auction.contractAddress);
      console.log(auction.ownerAddress);
      console.log(auction.bidderAddress);
      console.log(auction.bid);
      console.log(signer);
      console.logBytes32(r);
      console.logBytes32(s);
      console.log(v);
      //return (signatureVerify.verify(auction.tokenId, auction.contractAddress, auction.ownerAddress, auction.bidderAddress, auction.bid, signer, r, s, v));
      return signatureVerify.test();
    }

    modifier onlyInvolvedUsers (address sellerAddress,address buyerAddress){
      require(msg.sender == sellerAddress || msg.sender == buyerAddress, "NFTMarketplace.onlyInvolvedUsers: Only Buyer and Seller can execute this method");
      _;
    }

}