// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract TimeLock {
    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txID);
    error TimestampNotInRangeError(uint blocktimestamp, uint timestamp);
    error NotQueuedError(bytes32 txID);
    error TimestampNotPassedError(uint blocktimestamp, uint timestamp);
    error TimestampExpiredError(uint blocktimestamp, uint expiresAt);
    error TxFailedError();

    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 1000;
    uint public constant GRACE_PERIOD = 1000;

    address public owner;
    mapping(bytes32 => bool) public queued;

    event Queue(bytes32 indexed txID, address indexed target, uint value, string  func, bytes data, uint timestamp);
    event Execute(bytes32 indexed txID, address indexed target, uint value, string  func, bytes data, uint timestamp);
    event Cancel(bytes32 indexed txID);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwnerError();
        }
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function getTxID(address _target, uint _value, string calldata _func, bytes calldata _data, uint _timestamp) public pure returns(bytes32 txID) {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    /**
     * @param _target Address of contract or account to call
     * @param _value Amount of ETH to send
     * @param _func Function signature, for example "foo(address,uint256)"
     * @param _data ABI encoded data send.
     * @param _timestamp Timestamp after which the transaction can be executed.
     */
    function queue(address _target, uint _value, string calldata _func, bytes calldata _data, uint _timestamp) external onlyOwner {
        // create tx id
        bytes32 txID = getTxID(_target, _value, _func, _data, _timestamp);
        // check tx id unique
        if (queued[txID]) {
            revert AlreadyQueuedError(txID);
        }

        // ---|------------|---------------|-------
        //  block    block + min     block + max
        // check timestamp
        if (_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY) {
            revert TimestampNotInRangeError(block.timestamp, _timestamp);
        }

        // queue tx
        queued[txID] = true;

        emit Queue(txID, _target, _value, _func, _data, _timestamp);
    }


    function execute(address _target, uint _value, string calldata _func, bytes calldata _data, uint _timestamp) external payable onlyOwner returns(bytes memory) {
        bytes32 txID = getTxID(_target, _value, _func, _data, _timestamp);
        // check tx is queued
        if (!queued[txID]) {
            revert NotQueuedError(txID);
        }

        // ----|-------------------|------------------
        //  timestamp    timestamp + grace period
        // check block.timestamp > _timestamp
        if (block.timestamp < _timestamp) {
            revert TimestampNotPassedError(block.timestamp, _timestamp);
        }
        if (block.timestamp > _timestamp + GRACE_PERIOD) {
            revert TimestampExpiredError(block.timestamp, _timestamp + GRACE_PERIOD);
        }

        // delete tx from queue
        queued[txID] = false;

        // execute the tx
        bytes memory data;
        if (bytes(_func).length > 0) {
            // data = func selector + _data
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        }
        else {
            data = _data;
        }

        (bool ok, bytes memory res) = _target.call{value: msg.value}(_data);
        if (!ok) {
            revert TxFailedError();
        }

        emit Execute(txID, _target, _value, _func, _data, _timestamp);

        return res;
    }

    function cancel(bytes32 _txID) external onlyOwner {
        if (!queued[_txID]) {
            revert NotQueuedError(_txID);
        }
        queued[_txID] = false;

        emit Cancel(_txID);
    }

    receive() external payable {}
}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    function test() external {
        require(msg.sender == timeLock);

    }
}
