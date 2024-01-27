// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract CallOtherContract {
    function setX(address _test, uint _x) external {
        TestContract(_test).setX(_x);
    }

    function setX2(TestContract _test, uint _x) external {
        _test.setX(_x);
    }

    function getX(address _test) external view returns(uint) {
        //uint x = TestContract(_test).getX();
        //return x;

        return TestContract(_test).getX();
    }

    function setXandSendEther(address _test, uint _x) external payable {
        TestContract(_test).setXandReceiveEther{value: msg.value}(_x);
    }

    function getXandValue(address _test) external view returns(uint x, uint value) {
        (x, value) = TestContract(_test).getXandValue();

        // (uint x, uint value) = TestContract(_test).getXandValue();
        // return (x, value);
    }
}

contract TestContract {
    uint public x;
    uint public value = 123;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns(uint) {
        return x;
    }

    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns(uint, uint) {
        return (x, value);
    }
}

