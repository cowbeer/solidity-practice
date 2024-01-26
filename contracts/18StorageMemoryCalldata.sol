// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// storage: 指变量是状态变量
// memory: 指变量加载到内存
// calldata: 和memory类似，指变量加载到内存但只能用于函数输入参数，更节省gas
contract StorageMemoryCalldata {
    struct MyStruct {
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;

    function example(uint[] calldata x, uint[] memory y) external returns(uint[] memory) {
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});
        // 指明要使用的MyStruct是状态变量
        // 如果需要修改状态变量那么就要用storage
        MyStruct storage ms = myStructs[msg.sender];
        ms.text = "foo";

        MyStruct memory readOnly = myStructs[msg.sender];
        // 只是在内存中修改，不会改变状态
        readOnly.foo = 456;

        uint[] memory memArr = new uint[](3);
        memArr[0] = 234;

        // calldata是只读的
        // x[0] = 0;
        // memory在函数内部可以修改
        y[0] = 0;

        // 如果_internal的参数用memory声明则会先把y复制一个临时数组，再把临时数组传入_internal
        // 如果_internal的参数用calldata声明则会直接把y传入_internal
        // 因此calldata更省gas
        _internal(x);

        return memArr;
    }

    function _internal(uint[] calldata y) private {
        uint x = y[0];
    }
}
