// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Constants {
    // 对于永远不会变的状态变量就定义为常量
    // 读常量比读普通状态变量消耗的gas更少
    address public  constant MY_ADDRESS = 0x2cE76ba1CAF2fCEF777F64189d3fAa1229596071;
    uint public constant MY_UINT = 123;

}
