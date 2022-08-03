// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./Signature.sol";

contract NFTMarketplace is Signature{

    event CreateMarketSale(address erc721Address,uint256 tokenId,address sellerAddress,address buyerAddress,uint256 sellAmount,address erc20Address);
    event VerifySignature(bytes32 signature, address signer);

    constructor() Signature(address(this)) {}
    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function createMarketSale(
      address erc721Address,
      uint256 tokenId,
      address sellerAddress,
      address buyerAddress,
      uint256 sellAmount,
      address erc20Address
    ) public onlyInvolvedUsers(buyerAddress, sellerAddress){

      //require (verifySignature(auction, msg.sender, r, s, v), "NFTMarketplace.createMarketSale: This Address cannot create a market sale");
      //emit VerifySignature(signature, msg.sender);

      IERC721(erc721Address).safeTransferFrom(sellerAddress, buyerAddress, tokenId);
      IERC20(erc20Address).transferFrom(buyerAddress, sellerAddress, sellAmount);

      emit CreateMarketSale(erc721Address,tokenId,sellerAddress,buyerAddress,sellAmount,erc20Address);
    }


    modifier onlyInvolvedUsers (address sellerAddress,address buyerAddress){
      require(msg.sender == sellerAddress || msg.sender == buyerAddress, "NFTMarketplace.onlyInvolvedUsers: Only Buyer and Seller can execute this method");
      _;
    }

}