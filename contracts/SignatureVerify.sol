// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignatureVerify {

    struct Auction {
        uint256 tokenId;
        address contractAddress;
        address ownerAddress;
        address bidderAddress;
        uint256 bid;
    }
    string private constant types;
    bytes32 private constant DOMAIN_SEPARATOR;
    string private constant EIP712_DOMAIN = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)";


    constructor(address verifyingContract, string memory appName, string memory version, uint256 chainId, string memory data_type) {
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            EIP712_DOMAIN,
            keccak256(appName),
            keccak256(version),
            chainId,
            verifyingContract
        ));
    }


    function hashAuction(Auction auction) private pure returns (bytes32) {
        return keccak256(abi.encode(
            AUCTION_TYPE,
            auction.tokenId,
            auction.contractAddress,
            auction.ownerAddress,
            auction.bidderAddress,
            auction.bid
        ));
    }

    function hashMessage(Auction memory auction) private pure returns (bytes32){
        return keccak256(abi.encodePacked(
            "\\x19\\x01",
            DOMAIN_SEPARATOR,
            hashAuction(auction)
        ));
    }

    function verify(Auction memory auction, address signer, sigR, sigS, sigV) public pure returns (bool) {
        return signer == ecrecover(hashMessage(auction), sigV, sigR, sigS);
    }
}
