// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Event {
    event Log(string message, uint val);
    // 最能只能有3个indexed修饰的参数
    event IndexedLog(address indexed sender, uint val);

    function example() external {
        // event会里面的参数存在区块链上，因此函数不是view和pure
        emit Log("foo", 1234);
        emit IndexedLog(msg.sender, 789);
    }

    event Message(address indexed _from, address indexed _to, string message);

    function sendMessage(address _to, string calldata message) external {
        emit Message(msg.sender, _to, message);
    }
}
