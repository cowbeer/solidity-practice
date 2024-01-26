// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract X {
    function foo() public pure virtual returns(string memory) {
        return "X";
    }
    function bar() public pure virtual returns(string memory) {
        return "X";
    }
    function x() public pure returns(string memory) {
        return "X";
    }
}

contract Y is X {
    function foo() public pure virtual override returns(string memory) {
        return "Y";
    }
    function bar() public pure virtual override returns(string memory) {
        return "Y";
    }
    function y() public pure returns (string memory) {
        return "Y";
    }
}

contract Z is X {
    function foo() public pure virtual override returns(string memory) {
        return "Z";
    }
    function bar() public pure virtual override returns(string memory) {
        return "Z";
    }
    function z() public pure returns (string memory) {
        return "Z";
    }
}

// 要保证顺序
// 父合约放前面，兄弟合约顺序无关
contract V is X, Y, Z {
//contract V is X, Z, Y {
    // override里面的顺序无关
    function foo() public pure override(X, Z, Y) returns(string memory) {
        return "V";
    }

    function bar() public pure override(Z, Y, X) returns(string memory) {
        return "V";
    }
}