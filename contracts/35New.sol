// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Account {
    address public bank;
    address public owner;

    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;

    // 通过合约部署另一个合约
    function createAccount(address _owner) external payable {
        Account account = new Account{value: 123}(_owner);
        accounts.push(account);
    }
}
