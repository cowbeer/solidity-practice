// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Constructor {
    address public owner;
    uint public x;

    // 只在部署合约时调用一次
    // 通常用来初始化状态变量
    constructor(uint _x){
        x = _x;
        owner = msg.sender;
    }
}
