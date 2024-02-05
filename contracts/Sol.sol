// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

    error Unauthorized(address caller);

    function helper(uint x) pure returns(uint) {
        return x * 2;
    }