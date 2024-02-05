// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Array: dynamic or fixed size
// Initialization
// Insert(push), get, update, delete, pop, length
// Creating array in memory
// Returning array from function
contract Array {
    uint[] public nums = [1, 2, 3];
    uint[5] public numsFixed = [4, 5, 6, 7, 8];

    function example() external {
        nums.push(4); // [1,2,3,4]
        uint x = nums[1];
        nums[2] = 30; // [1,2,30,4]

        // 对应的元素改为默认值，不会改变数组大小
        delete nums[1]; // [1,0,30,4]

        // 删除数组最后一个元素，数组大小减1
        nums.pop(); // [1,0,30]
        uint len = nums.length;

        // create array in memory
        // 要使用memory关键字并且只能创建固定大小的数组
        uint[] memory a = new uint[](5);

        // 内存数组不能使用pop和push方法
        //a.pop();
        //a.push(6);

        a[1] = 123;
    }

    // memory意义是复制状态变量nums到memory
    function returnArray() external view returns(uint[] memory) {
        return nums;
    }

    uint[] public arr;
    function deleteElement() public {
        arr = [1, 2, 3];
        delete arr[1]; // [1, 0, 3]
    }

    // 通过移动删除数组中的某个元素
    // [1, 2, 3] -> remove(1) -> [1, 3, 3] -> pop() -> [1,3]
    // [1, 2, 3, 4, 5, 6] -> remove(2) ->  [1, 2, 4, 5, 6, 6] -> pop() -> [1, 2, 4, 5, 6]
    // [1] -> remove(0) -> []
    function removeByShifting(uint _index) public {
        require(_index < arr.length, "index out of bound");
        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i+1];
        }
        arr.pop();
    }

    function testRemoveByShifting() external {
        arr = [1, 2, 3, 4, 5];
        removeByShifting(2); // [1, 2, 4, 5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 3);
        assert(arr[3] == 4);
        assert(arr.length == 4);

        arr = [1];
        removeByShifting(0); // []
        assert(arr.length == 0);
    }

    // 通过交换删除数组中的某个元素
    // [1, 2, 3, 4] -> remove(1) -> [1, 4, 3]
    // [1, 4, 3] -> remove(2) -> [1, 4]
    function removeByReplacingLast(uint _index) public {
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }

    function testRemoveByReplacingLast() external {
        arr = [1, 2, 3, 4];
        removeByReplacingLast(1); // [1, 4, 3]
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);
        assert(arr.length == 3);

        removeByReplacingLast(2); // [1, 4]
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr.length == 2);
    }
}
