// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract GlobalVar {
    function globalVars() external view returns(address, uint, uint) {
        address sender = msg.sender;
        uint timestamp = block.timestamp; // unix timestamp of when this function was called
        uint blockNum = block.number;
        return (sender, timestamp, blockNum);
    }
}
