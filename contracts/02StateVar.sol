// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract StateVar {
    // 状态变量定义在合约内函数外，会存储在区块链上
    uint public myUint = 123;

    function foo() external pure returns (uint) {
        // 局部变量只在函数内有效
        uint notStateVar = 456;
        return notStateVar;
    }
}
