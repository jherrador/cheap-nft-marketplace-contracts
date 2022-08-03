// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SignatureVerify {
    struct Auction {
        uint256 tokenId;
        address contractAddress;
        address ownerAddress;
        address bidderAddress;
        uint256 bid;
    }

    string private constant EIP712_DOMAIN = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)";
    string private constant AUCTION_TYPE = "Auction(uint256 tokenId, address contractAddress, address ownerAddress, address bidderAddress, uint256 bid)";
    bytes32 private DOMAIN_SEPARATOR;

    constructor(address verifyingContract, uint256 chainId) {
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            EIP712_DOMAIN,
            keccak256("Cheap NFT Marketplace"),
            keccak256("1"),
            chainId,
            verifyingContract
        ));
    }

    function hashMessage(Auction memory auction) private view returns (bytes32){
        return keccak256(abi.encodePacked(
            "\\x19\\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(
                AUCTION_TYPE,
                auction.tokenId,
                auction.contractAddress,
                auction.ownerAddress,
                auction.bidderAddress,
                auction.bid
            ))
        ));
    }
    function test() external pure returns(bool) {
        return true;
    }
    function verify(uint256 tokenId, address contractAddress, address ownerAddress, address bidderAddress, uint256 bid, address signer, bytes32 r, bytes32 s, uint8 v) public view returns (bool) {
        console.log("ADIOS");
        Auction memory auction;

        auction.tokenId = tokenId;
        auction.contractAddress = contractAddress;
        auction.ownerAddress = ownerAddress;
        auction.bidderAddress = bidderAddress;
        auction.bid = bid;
        
        console.log(auction.tokenId);
        console.log(auction.contractAddress);
        console.log(auction.ownerAddress);
        console.log(auction.bidderAddress);
        console.log(auction.bid);

        console.log(signer);
        console.logBytes32(r);
        console.log(v);
        console.logBytes32(s);
        // return signer == ecrecover(hashMessage(auction), v, r, s);
    }
}
