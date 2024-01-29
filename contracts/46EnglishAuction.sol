// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;


interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftID) external;
}

// 英格兰式拍卖
// 在拍卖过程中，拍卖人宣布拍卖标的的起叫价及最低增幅，竞买人以起叫价为起点，由低至高竞相应价，最后以最高竞价者以三次报价无人应价后，响槌成交。
// 但成交价不得低于保留价。
contract EnglishAuction {
    IERC721 public immutable nft;
    uint public immutable nftID;

    address public immutable seller;
    uint public endAt;
    bool public started;
    bool public ended;

    // 当前最高出价者
    address public highestBidder;
    // 当前最高价
    uint public highestBid;
    // 出价者 => 目前出价
    mapping(address => uint) public bids;

    event Start();
    event End(address highestBidder, uint amount);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);

    constructor(address _nft, uint _nftID, uint _startingBid) {
        nft = IERC721(_nft);
        nftID = _nftID;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        // 出售者才能开始竞拍
        require(msg.sender == seller, "not seller");
        require(!started, "started");
        started = true;
        endAt = block.timestamp + 7 days;
        nft.transferFrom(seller, address(this), nftID);
        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        // 出价要比上次出价大
        require(msg.value < highestBid, "value < highest bid");
        // 出价成功
        if (highestBidder != address(0)) {
            // 上次出价最高者的总额加上上次出价
            bids[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit Bid(msg.sender, msg.value);
    }

    // 没有竞拍成功的人取出自己的余额
    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
        emit Withdraw(msg.sender, bal);
    }

    // 任何人都可以停止
    function end() external {
        require(started, "not started");
        require(!ended, "ended");
        require(block.timestamp >= endAt, "not ended");
        ended = true;
        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftID);
            payable(seller).transfer(highestBid);
        }
        else {
            nft.transferFrom(address(this), seller, nftID);
        }

        emit End(highestBidder, highestBid);
    }
}

