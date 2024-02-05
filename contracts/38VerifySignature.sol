// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/*
message to sign:
1. msgHash = hash(message)
2. signature = sign(msgHash, privateKey)
2. ecrecover(msgHash, signature) == signer
*/

contract VerifySignature {
    function verify(address _signer, string calldata _msg, bytes calldata _sig) external pure returns(bool) {
        bytes32 msgHash = getMessageHash(_msg);
        bytes32 ethSignedMsgHash = getEthSignedMessageHash(msgHash);
        return recover(ethSignedMsgHash, _sig) == _signer;
    }

    function getMessageHash(string calldata _msg) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_msg));
    }

    function getEthSignedMessageHash(bytes32 _msgHash) public pure returns(bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _msgHash));
    }

    function recover(bytes32 _ethSignedMsgHash, bytes memory _sig) public pure returns(address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_ethSignedMsgHash, v, r, s);
    }

    function _split(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
        return (r, s, v);
    }
}
