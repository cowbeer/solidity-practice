// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }
    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo({
            text: _text,
            completed: false
        }));
    }

    function updateText(uint _index, string calldata _text) external {
        //如果只修改一个字段
        // 更省gas
        todos[_index].text = _text;
        // gas更多
        Todo storage todo = todos[_index];
        todo.text = _text;

        // 如果修改多个字段
        // gas更多：每次都需要寻址拿到对应的元素
        todos[_index].text = _text;
        todos[_index].text = _text;
        todos[_index].text = _text;
        todos[_index].text = _text;
        // 更省gas：只寻址一次
        Todo storage todo2 = todos[_index];
        todo2.text = _text;
        todo2.text = _text;
        todo2.text = _text;
        todo2.text = _text;
    }

    function get(uint _index) external view returns(string memory, bool) {
        // 消耗gas更多，先拷贝todos[_index]到todo，再todo拷贝到返回值
        Todo memory todo = todos[_index];

        // 更省gas，直接把todos[_index]拷贝到返回值
        Todo storage todo2 = todos[_index];

        return (todo.text, todo.completed);
    }

    function toggleCompleted(uint _index) external {
        todos[_index].completed = !todos[_index].completed;
    }
}
