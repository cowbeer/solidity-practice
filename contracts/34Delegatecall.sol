// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/*
A calls B, sends 100 wei
        B calls C, sends 50 wei

A --> B --> C
            msg.sender = B
            msg.value = 50
            execute code on C's state variables
            use ETH in C


A calls B, sends 100 wei
        B delegatecall C

A --> B --> C
            msg.sender = A
            msg.value = 100
            execute code on B's state variables
            use ETH in B

delegatecall保存了上下文
*/

contract TestDelegateCall {
    uint    public num;
    address public sender;
    uint    public value;

    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

// 在本例中通过delegatecall相当于可以更新TestDelegateCall合约: 因为修改的状态变量在Delegatecall合约中，因此TestDelegateCall合约可以修改逻辑重新部署
contract Delegatecall {
    // 注意：
    // 变量的定义顺序要和TestDelegateCall合约一致
    uint    public num;
    address public sender;
    uint    public value;

    function setVars(address _test, uint _num) external payable {
        //_test.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));

        (bool success, bytes memory data) = _test.delegatecall(abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num));
        require(success, "delegatecall failed");

    }
}
