// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract A {
    // virtual表示该函数可被继承并可以被子合约自定义
    function foo() public pure virtual returns(string memory) {
        return "A";
    }

    function bar() public pure virtual returns(string memory) {
        return "A";
    }

    function baz() public pure returns(string memory) {
        return "A";
    }
}

contract B is A {
    // override表示覆盖了父合约的函数
    function foo() public pure override returns(string memory) {
        return "B";
    }

    function bar() public pure virtual override returns(string memory) {
        return "B";
    }

    // 注意
    // 没有覆盖baz()函数，B中也有baz函数但返回"A"
}

contract C is B {
    function bar() public pure override returns(string memory) {
        return "C";
    }

    // C中的foo函数返回"B"
    // C中的bar函数返回"C"
    // C中的baz函数返回"A"
}