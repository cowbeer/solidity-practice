// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// require, revert, assert
// when an error thrown inside a transaction, your gas will be refunded
// any state variables that were updated will be reverted
// custom error: save gas
contract Error {
    // require通常用于参数检查和访问控制
    function testRequire(uint _i) public pure {
        require(_i <= 0, "i > 10");
    }

    function testRevert(uint _i) public pure {
        if (_i > 100) {
            revert("i > 100");
        }

        // 如果嵌套在大量if条件中，revert是更好的选择
        if (_i > 1) {
            if (_i > 2) {
                if (_i > 10) {
                    revert("i > 10");
                }
            }
        }

    }

    uint public num = 123;
    function testAssert() public view {
        assert(num == 123);
    }

    function foo(uint _i) public {
        num += 1;
        require(_i < 10);
    }

    error MyError(address caller, uint i);
    function testCustomError(uint _i) public view {
        //require(_i <= 10, "very very long error message");
        if (_i > 10) {
            revert MyError(msg.sender, _i);
        }
    }
}
