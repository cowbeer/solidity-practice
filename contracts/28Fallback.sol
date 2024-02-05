// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/*
Fallback executed when:
    function doesn't exist
    directly send ETH

fallback() or receive() ?
      ETH is sent to contract
               |
         is msg.data empty?
             /   \
          yes     no
          /         \
receive() exist?    fallback()
       /   \
    yes    no
    /        \
receive()   fallback()

*/


contract Fallback {
    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
}
