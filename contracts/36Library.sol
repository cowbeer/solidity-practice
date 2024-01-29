// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

library Math {
    function max(uint _x, uint _y) internal pure returns(uint){
        return _x >= _y ? _x : _y;
    }
}

contract Test {
    function setMax(uint _x, uint _y) external pure returns(uint) {
        return Math.max(_x, _y);
    }
}

library ArrayLib {
    function find(uint[] storage arr, uint x) internal view returns(uint){
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == x) {
                return i;
            }
        }
        revert("not found");
    }
}

contract TestArray {
    using ArrayLib for uint[];

    uint[] public arr = [3, 2, 1];

    function getFind() external view returns(uint i) {
        // return ArrayLib.find(arr, 2);
        return arr.find(2);
    }
}