// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 可以从其他合约导入
import { Unauthorized, helper as h1 } from "./Sol.sol";

// function outside contract
function helper(uint x) pure returns(uint) {
    return h1(x);
}

contract Import {
    function test() external view returns(uint) {
        if (msg.sender == address(0)) {
            revert Unauthorized(msg.sender);
        }

        return helper(123);
    }
}
