// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// return multiple outputs
// named outputs
// destructuring assigment
contract FunctionOutput {
    function returnMany() public pure returns(uint, bool) {
        return (1, true);
    }

    function named() public pure returns(uint x, bool b) {
        return (1, true);
    }

    // 会节省一些gas
    function assigned() public pure returns(uint x, bool b) {
        x = 1;
        b = true;
    }

    function destructuringAssignments() public pure returns (uint, bool) {
        (uint x, bool b) = returnMany();
        (, bool c) = returnMany();
        b = c;
        return (x, b);
    }
}
