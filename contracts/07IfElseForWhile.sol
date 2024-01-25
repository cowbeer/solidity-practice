// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract IfElseForWhile {
    function example(uint _x) external pure returns (uint) {
        if (_x < 10) {
            return 1;
        } else if (_x < 20) {
            return 2;
        } else {
            return 3;
        }
    }

    function ternary(uint _x) external pure returns (uint) {
        // 可用三目运算符
        return _x < 10 ? 1 : _x < 20 ? 2: 3;
    }

    // 循环次数越多，消耗的gas越多
    function loops() external pure {
        for (uint i = 0; i < 10; i++) {
            if (i == 3) {
                continue;
            }
            if (i == 5) {
                break;
            }
        }

        uint j = 0;
        while(j < 10) {
            j++;
        }
    }

    function sum(uint _n) external pure returns (uint) {
        uint s;
        for (uint i = 1; i <= _n; i++) {
            s += i;
        }
        return s;
    }
}
