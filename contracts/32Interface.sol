// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Counter {
    uint public count;
    function inc() external { count += 1; }
    function dex() external { count -= 1; }
}

interface ICounter {
    function count() external view returns(uint);
    function inc() external;
    function dec() external;
}

contract CallInterface {
    function example(address _counter) external {
        // Counter(_counter).inc();

        ICounter(_counter).inc();
        ICounter(_counter).count();
    }
}
