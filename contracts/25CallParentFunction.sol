// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
/*
   E
 /   \
 F    G
  \  /
   H
直接调用父合约函数就只调用父合约函数
通过super调用父合约函数会把继承路线上所有的有关的super调用都调用一遍
*/
contract E {
    event Log(string message);

    function foo() public virtual {
        emit Log("E.foo");
    }

    function bar() public virtual {
        emit Log("E.bar");
    }
}

contract F is E {
    function foo() public virtual override {
        emit Log("F.foo");

        // 直接调用父合约的函数
        E.foo();
    }

    function bar() public virtual override {
        emit Log("F.bar");

        // 通过super调用父合约的函数
        super.bar();
    }
}

contract G is E {
    function foo() public virtual override {
        emit Log("G.foo");
        E.foo();
    }

    function bar() public virtual override {
        emit Log("G.bar");
        super.bar();
    }
}

contract H is F, G {
    function foo() public override(F, G) {
        // "F.foo" -> "E.foo"
        F.foo();
    }

    function bar() public override(F, G) {
        // "G.bar" -> "H.bar" -> "E.bar"
        super.bar();
    }
}