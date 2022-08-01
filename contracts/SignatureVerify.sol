// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignatureVerify {
    function VerifyMessage(
        string memory _hashedMessage,
        bytes memory _signature
    ) public pure returns (address) {
        uint8 v;
        bytes32 r;
        bytes32 s;
        (v, r, s) = splitSignature(_signature);
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHashMessage = keccak256(
            abi.encodePacked(prefix, _hashedMessage)
        );
        address signer = ecrecover(prefixedHashMessage, v, r, s);
        return signer;
    }

    function splitSignature(bytes memory signatureHash)
        internal
        pure
        returns (
            uint8,
            bytes32,
            bytes32
        )
    {
        require(signatureHash.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(signatureHash, 32))
            // second 32 bytes
            s := mload(add(signatureHash, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(signatureHash, 96)))
        }

        return (v, r, s);
    }
}
