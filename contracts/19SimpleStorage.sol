// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SimpleStorage {
    string public text;

    function set(string calldata _text) external {
        text = _text;
    }

    function get() external view returns (string memory) {
        return text;
    }
}
