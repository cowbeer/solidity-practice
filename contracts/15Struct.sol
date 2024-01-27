// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Struct {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    function examples() external {
        // memory即在内存中创建，只在函数内有效
        Car memory hongqi = Car("Hongqi", 1990, msg.sender);
        Car memory changan = Car({model: "Changan", year: 1980, owner: msg.sender});
        Car memory byd; // 所有字段都是默认值 {model: "", year: 0, owner: 0x0000000000000000000000000000000000000000}
        byd.model = "BYD";
        byd.year = 2010;
        byd.owner = msg.sender;
        cars.push(hongqi);
        cars.push(changan);
        cars.push(byd);
        cars.push(Car("Tank", 2020, msg.sender));

        // 改变状态变量要使用storage关键字
        // 如果使用memory那么就是在内存中修改，并不会改变状态
        Car storage _car = cars[0];
        _car.year = 1999;
        // 将owner改为默认值
        delete _car.owner;
        // 将下标为1的car所有字段都置为默认值
        delete cars[1];
    }
}
