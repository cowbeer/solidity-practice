// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract TestCall {
    string public message;
    uint public x;

    event Log(string message);

    function foo(string calldata _message, uint _x) external payable returns(bool, uint) {
        message = _message;
        x = _x;
        return (true, 999);
    }

    fallback() external payable {
        emit Log("fallback was called");
    }
}

contract Call {
    bytes public data;

    function callFoo(address _test) external payable {
        // 注意uint要写成uint256
        (bool success, bytes memory _data) = _test.call{value: 111, gas: 5000}(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
        require(success, "call failed");
        data = _data;
    }

    function callDoesNotExist(address _test) external {
        (bool success,) = _test.call(abi.encodeWithSignature("doesNotExist"));
        require(success, "call failed");
    }
}
