// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// Function Modifier: reuse code before and/or after function
contract FunctionModifier {
    bool public paused;
    uint public count;

    function setPause(bool _paused) external {
        paused = _paused;
    }

    // 不带参数
    modifier whenNotPaused() {
        require(!paused, "paused");
        _;
    }

    function inc() external whenNotPaused {
        //require(!paused, "paused");
        count += 1;
    }

    function dec() external whenNotPaused {
        //require(!paused, "paused");
        count -= 1;
    }

    // 带参数
    modifier cap(uint _x) {
        require(_x < 100, "x >= 100");
        _;
    }

    function incBy(uint _x) external whenNotPaused cap(_x) {
        count += _x;
    }

    modifier sandwich() {
        count += 10;
        _;
        count *=2;
    }

    function foo() external sandwich {
        count += 1;
    }
}
