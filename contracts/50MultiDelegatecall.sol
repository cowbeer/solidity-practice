// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


contract MultiDelegateCall {
    error DelegateCallFailed();

    function multiDelegateCall(bytes[] calldata data) external payable returns(bytes[] memory) {
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < data.length; i++) {
            (bool ok, bytes memory res) = address(this).delegatecall(data[i]);
            if (!ok) {
                revert DelegateCallFailed();
            }
            results[i] = res;
        }

        return results;
    }
}

contract TestMultiDelegateCall is MultiDelegateCall {
    event Log(address caller, string func, uint i);

    function func1(uint _x, uint _y) external {
        emit Log(msg.sender, "func1", _x + _y);
    }

    function func2() external returns(uint) {
        emit Log(msg.sender, "func2", 2);
        return 123;
    }

    mapping(address => uint) public balanceOf;

    // unsafe code when used in combination with multi-delegatecall
    // user can mint multiple times for the price of msg.value
    function mint() external payable {
        balanceOf[msg.sender] += msg.value;
    }
}

contract Helper {
    function getFuncData(uint _x, uint _y) external pure returns(bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.func1.selector, _x, _y);
    }

    function getFunc2Data() external pure returns(bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.func2.selector);
    }

    function getMintData() external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.mint.selector);
    }
}