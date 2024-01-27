// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// safe math
contract NewFeature {
    // 运行时会报错
    function testUnderflow() public pure returns(uint) {
        uint x = 0;
        x--;
        return x;
    }

    // 运行时不报错，但会返回一个很大的数
    function testUncheckedUnderflow() public pure returns(uint) {
        uint x = 0;
        unchecked{ x--; }
        return x;
    }
}
