// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Immutable {
    // immutable变量只能在合约部署时被初始化一次
    // 更省gas
    address public immutable owner;

    uint public x;

    constructor() {
        owner = msg.sender;
    }

    function foo() external {
        require(msg.sender == owner, "not owner");
        x += 1;
    }
}

contract Payable {
    // payable修饰函数表示该地址可以发送ETH
    address payable public owner;

    constructor() {
        // 显式地将address转成payable address
        owner = payable(msg.sender);
    }

    // payable修饰函数表示该函数时可以发送或接收ETH
    function deposit() external payable {

    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }
}