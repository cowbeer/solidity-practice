// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftID) external;
}

// 荷兰式拍卖
// 指在拍卖过程中，拍卖人宣布拍卖标的的起拍价及降幅，并依次叫价，第一位应价人响槌成交。但成交价不得低于保留价。
contract DutchAuction {
    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftID;

    address payable public immutable seller;
    // 起拍价格（最高价格）
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expireAt;
    // 每次的降幅
    uint public immutable discountRate;

    constructor(uint _startingPrice, uint _discountRate, address _nft, uint _nftID) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expireAt = block.timestamp + DURATION;

        require(_startingPrice >= _discountRate * DURATION, "staring price < discount");

        nft = IERC721(_nft);
        nftID = _nftID;
    }

    function getPrice() public view returns(uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expireAt, "auction expired");

        uint price = getPrice();
        require(msg.value >= price, "ETH < price");

        nft.transferFrom(seller, msg.sender, nftID);
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        selfdestruct(seller);
    }
}
