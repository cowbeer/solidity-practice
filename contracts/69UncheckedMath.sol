// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract UncheckedMath {
    function add(uint x, uint y) external pure returns(uint) {
        // return x + y;
        // 如果能保证不溢出，unchecked更省gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint x, uint y) external pure returns(uint) {
        // return x - y;
        unchecked {
            return x - y;
        }
    }

    function sumOfCubes(uint x, uint y) external pure returns(uint) {
        unchecked {
            uint x3 = x * x * x;
            uint y3 = y * y * y;
            return x3 + y3;
        }
    }
}
