// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract FunctionSelector {
    function getSelector(string calldata _func) external pure returns(bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

contract Receiver {
    event Log(bytes data);

    function transfer(address _to, uint _amount) external {
        emit Log(msg.data);
        // 调用合约函数其实就是在交易的数据附加一段数据：
        // 0x + 函数签名（如"transfer(address,uint256)"）哈希值（取前8个字符）+ 参数1（按32字节补0）+ 参数2 + ...
        // 0xa9059cbb
        // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
        // 000000000000000000000000000000000000000000000000000000000000007b
    }
}
