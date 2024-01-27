// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Keccak256 {
    function hash(string memory text, uint num, address addr) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text, num, addr));
    }

    // abi.encode: 非压缩编码会补0
    function encode(string memory text0, string memory text1) external pure returns (bytes memory) {
        return abi.encode(text0, text1);
    }

    // abi.encodePacked: 压缩编码不会补0
    // "AAAA","BBB" -> 0x41414141424242
    // "AAA","ABBB" -> 0x41414141424242
    // keccak256(abi.encodePacked("AAAA", "BBB"))与keccak256(abi.encodePacked("AAA", "ABBB"))产生碰撞
    function encodePacked(string memory text0, string memory text1) external pure returns (bytes memory) {
        return abi.encodePacked(text0, text1);
    }

    // 可以在两个字符串之间插入非字符串类型的参数来避免碰撞
    function collision(string memory text0, uint x, string memory text1) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text0, x, text1));
    }
}
