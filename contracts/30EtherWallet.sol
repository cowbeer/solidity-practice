// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");

        // 不读状态变量可以节省gas
        // owner.transfer(_amount);
        payable(msg.sender).transfer(_amount);

        //
        // (bool sent, ) = msg.sender.call{value: _amount}("");
        // require(sent, "failed to send ether");
    }

    function getBalance() external returns(uint) {
        return address(this).balance;
    }

    receive() external payable {}
}
