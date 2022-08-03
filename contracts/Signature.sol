// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Signature {

    struct Auction {
        uint256 tokenId;
        address contractAddress;
        address ownerAddress;
        address bidderAddress;
        uint256 bid;
    }

    string private constant EIP712_DOMAIN = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)";
    string private constant AUCTION_TYPE = "Auction(uint256 tokenId, address contractAddress, address ownerAddress, address bidderAddress, string bid)";
    bytes32 private DOMAIN_SEPARATOR;

    constructor(address verifyingContract) {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256(abi.encodePacked(EIP712_DOMAIN)),
            keccak256(bytes("Cheap NFT Marketplace")),
            keccak256(bytes("1")),
            chainId,
            verifyingContract
        ));
    }

    function hashMessage(Auction memory auction) private view returns (bytes32){
        return keccak256(abi.encodePacked(
            "\\x19\\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(
                keccak256(abi.encode(AUCTION_TYPE)),
                auction.tokenId,
                auction.contractAddress,
                auction.ownerAddress,
                auction.bidderAddress,
                auction.bid
            ))
        ));
    }
    function verifySignature(Auction memory auction, address signer, bytes32 r, bytes32 s, uint8 v) public view returns (bool) {

        return signer == ecrecover(hashMessage(auction), v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        view
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        
        require(sig.length == 65);

        assembly {
            // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
            // second 32 bytes.
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }
        return (v, r, s);
    }
}