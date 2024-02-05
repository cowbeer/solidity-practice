// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

contract U is S("s"), T("t") {

}

contract V is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {

    }
}

contract VV is S("s"), T {
    constructor(string memory _text) T(_text) {

    }
}

// 执行顺序只跟继承顺有关
// order of execution: S -> T -> V0
contract V0 is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {

    }
}

// order of execution: S -> T -> V1
contract V1 is S, T {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {

    }
}

// order of execution: T -> S -> V2
contract V2 is T, S {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {

    }
}

// order of execution: T -> S -> V3
contract V3 is T, S {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {

    }
}