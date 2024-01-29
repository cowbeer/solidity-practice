// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract PiggyBank {
    address public owner = msg.sender;

    event Deposit(uint amount);
    event Withdraw(uint amount);

    function withdraw() external {
        require(msg.sender == owner, "not owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }

    receive() external payable {
        emit Deposit(msg.value);
    }
}
