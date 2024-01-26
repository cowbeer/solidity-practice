// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// visibility
// private: only inside contract
// internal: only inside contract and child contracts
// public: inside and outside contract
// external: only from outside contract

contract VisibilityBase {
    uint private x = 0;
    uint internal y = 1;
    uint public z = 2;

    function privateFunc() private pure {}
    function internalFunc() internal pure {}
    function publicFunc() public pure {}
    function externalFunc() external pure {}

    function example() external view {
        x + y + z;

        privateFunc();
        internalFunc();
        publicFunc();

        // Error
        // externalFunc();

        // 通过this调用外部函数
        this.externalFunc();
    }
}

contract VisibilityChild is VisibilityBase {
    function example2() external view {
        y + z;
        internalFunc();
        publicFunc();
        this.externalFunc();
    }
}
