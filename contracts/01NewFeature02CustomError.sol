// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// 也可以定义在合约外面，也可以从其他合约导入
error InvalidAmount();

// custom error
contract VendingMachine {
    address payable owner = payable(msg.sender);

    error Unauthorized(address caller);

    function withdraw() payable public {
        if (msg.sender != owner) {
            // 字符串越长用gas越多
            // revert("error");

            // 自定义错误比写字符串用gas更少
            revert Unauthorized(msg.sender);
        }

        if (msg.value == 0) {
            revert InvalidAmount();
        }

        owner.transfer(address(this).balance);
    }
}
