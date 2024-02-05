// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Enum {
    enum Status{
        None,     // 0
        Pending,  // 1
        Shipped,  // 2
        Rejected, // 3
        Canceled  // 4
    }
    Status public status;

    struct Order {
        address buyer;
        Status status;
    }
    Order[] public orders;

    function get() external view returns (Status) {
        return status;
    }

    function set(Status _status) external {
        status = _status;
    }

    function ship() external {
        status = Status.Shipped;
    }

    function reset() external {
        // 重置为默认值即enum中第一个值
        delete status;
    }
}
