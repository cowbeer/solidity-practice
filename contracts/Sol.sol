// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

    error Unauthorized(address caller);

    function helper(uint x) pure returns(uint) {
        return x * 2;
    }