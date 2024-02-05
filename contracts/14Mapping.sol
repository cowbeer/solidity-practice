// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Mapping: set, get, delete
contract Mapping {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => bool)) public isFriend;
    mapping(address => bool) public inserted;
    address[] public keys;

    function examples() external {
        balances[msg.sender] = 123;
        uint bal = balances[msg.sender];
        // key不存在就返回value的默认值
        uint bal2 = balances[address(1)]; // 0
        balances[msg.sender] += 456; // 123 + 456
        // 并不是删除，而是重置为默认值
        delete balances[msg.sender]; // 0
        isFriend[msg.sender][address(this)] = true;
    }

    function set(address _key, uint _val) external {
        balances[_key] = _val;
        if (!inserted[_key]) {
            inserted[_key] = true;
            keys.push(_key);
        }
    }

    function getSize() external view returns (uint) {
        return keys.length;
    }

    function first() external view returns(uint) {
        return balances[keys[0]];
    }

    function last() external view returns(uint) {
        return balances[keys[keys.length-1]];
    }

    function get(uint _i) external view returns(uint) {
        return balances[keys[_i]];
    }
}
