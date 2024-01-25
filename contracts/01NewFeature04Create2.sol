// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 合约地址生成方式：
// create: keccak256(senderAddress, nonce)，每次部署后，合约地址会改变
// create2: keccak256(0xFF, senderAddress, salt, bytecode)，只要给定的参数不变，地址就不变，就可以在不部署合约的情况下，提前算出地址
// 0xFF is a constant to prevent collision with CREATE opcode.
// salt is a value sender sends when deploying contract.
// bytecode is the bytecode of the smart contract you want to deploy.
//

// salted contract creations / create2
contract D {
    uint public x;
    constructor(uint a) {
        x = a;
    }
}

contract Create2 {
    address public deployedAddr;

    function getBytes32(uint salt) external pure returns(bytes32) {
        return bytes32(salt);
    }

    function getAddress(bytes32 salt, uint arg) external view returns(address) {
        address addr = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(type(D).creationCode, arg))
        )))));

        return addr;
    }

    function createDSalted(bytes32 salt, uint arg) public {
        // 带盐创建D合约
        D d = new D{salt: salt}(arg);
        deployedAddr = address(d);
    }
}
