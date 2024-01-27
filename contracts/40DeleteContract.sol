// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/*
selfdestruct:
delete contract
force send Ether to any address
*/
contract Kill {
    constructor() payable {

    }

    function kill() external {
        // 把即将销毁的合约的全部余额转给msg.sender
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns(uint) {
        return 123;
    }
}

contract Helper {
    function getBalance()external view returns(uint) {
        return address(this).balance;
    }
    // Helper没有fallback函数也能收到Kill合约销毁时发出的ETH
    function kill(Kill _kill) external {
        _kill.kill();
    }
}