// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract ViewAndPureFunction {
    uint public num;

    // 不修改状态变量，只读状态变量
    function viewFunc() external view returns (uint) {
        return num;
    }

    // 不仅不修改状态变量也不读状态变量
    function pureFunc() external pure returns (uint) {
        return 1;
    }

    // 使用了（读）状态变量，并未修改它
    function addToNum(uint x) external view returns (uint) {
        return num + x;
    }

    // 没有修改和读任何状态变量
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
}
