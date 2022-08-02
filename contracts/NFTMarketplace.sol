// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SignatureVerify.sol";

import "hardhat/console.sol";

contract NFTMarketplace {
    SignatureVerify public signatureVerify;

    event CreateMarketSale(address erc721Address,uint256 tokenId,address sellerAddress,address buyerAddress,uint256 sellAmount,address erc20Address);

    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function createMarketSale(
      address erc721Address,
      uint256 tokenId,
      address sellerAddress,
      address buyerAddress,
      uint256 sellAmount,
      address erc20Address,
      string memory _hashedMessage,
      bytes memory _signature
      
      
      ) public {
      //requires
      require (msg.sender == signatureVerify.VerifyMessage(_hashedMessage,_signature), "NFTMarketplace.createMarketSale: This Address cannot create a market sale");

      IERC721(erc721Address).safeTransferFrom(sellerAddress, buyerAddress, tokenId);
      IERC20(erc20Address).transferFrom(buyerAddress, sellerAddress, sellAmount);

      emit CreateMarketSale(erc721Address,tokenId,sellerAddress,buyerAddress,sellAmount,erc20Address);
    }

    function createMarketSaleWithoutSignature(
      address erc721Address,
      uint256 tokenId,
      address sellerAddress,
      address buyerAddress,
      uint256 sellAmount,
      address erc20Address
      ) public {
      
      IERC721(erc721Address).safeTransferFrom(sellerAddress, buyerAddress, tokenId);
      IERC20(erc20Address).transferFrom(buyerAddress, sellerAddress, sellAmount);

      emit CreateMarketSale(erc721Address,tokenId,sellerAddress,buyerAddress,sellAmount,erc20Address);
    }

}