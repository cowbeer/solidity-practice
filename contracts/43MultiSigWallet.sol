// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txID);
    event Approve(address indexed owner, uint indexed txID);
    event Revoke(address indexed owner, uint indexed txID);
    event Execute(uint indexed txID);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;
    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint _txID) {
        require(_txID < transactions.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txID) {
        require(!approved[_txID][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txID) {
        require(!transactions[_txID].executed, "tx already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required");
        require(_required > 0 && _required <= _owners.length, "invalid required number of owners");

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({to: _to, value: _value, data: _data, executed: false}));
        emit Submit(transactions.length-1);
    }

    function approve(uint _txID) external onlyOwner txExists(_txID) notApproved(_txID) notExecuted(_txID) {
        approved[_txID][msg.sender] = true;
        emit Approve(msg.sender, _txID);
    }

    function _getApprovalCount(uint _txID) private view returns(uint) {
        uint count;
        for (uint i; i < owners.length; i++) {
            if (approved[_txID][owners[i]]) {
                count += 1;
            }
        }
        return count;
    }

    function execute(uint _txID) external txExists(_txID) notExecuted(_txID) {
        require(_getApprovalCount(_txID) >= required, "approvals < required");
        Transaction storage txn = transactions[_txID];
        txn.executed = true;
        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        require(success, "txn failed");
        emit Execute(_txID);
    }

    function revoke(uint _txID) external onlyOwner txExists(_txID) notExecuted(_txID) {
        require(approved[_txID][msg.sender], "tx not approved");
        approved[_txID][msg.sender] = false;
        emit Revoke(msg.sender, _txID);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
