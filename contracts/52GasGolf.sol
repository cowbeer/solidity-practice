// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/*
use calldata
load state variables to memory
short circuit
loop increments
cache array length
load array elements to memory
*/
contract GasGolf {
    uint public total;

//    function sumIfEvenAdnLessThan99(uint[] memory nums) external { // memory比calldata消耗的gas多
//        for (uint i = 0; i < nums.length; i += 1) { // 消耗gas: ++i < i++ < i+=1 ; 每次都要计算length
//            bool isEven = nums[i] % 2 == 0; // 无论是否满足条件都要做两次计算
//            bool isLessThan99 = nums[i] < 99; // 利用短路特性在不满足条件的情况下可以减少一次计算
//            if (isEven && isLessThan99) {
//                total += nums[i]; // 每次满足条件都会读写状态变量会消耗很多gas
//            }
//        }
//    }

    // [1,2,3,4,5,100]
    function sumIfEvenAdnLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint len = nums.length;
        for (uint i = 0; i < len; ++i) {
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }

        total = _total;
    }
}
