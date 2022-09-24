// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FeeCollector {
    address private immutable owner;
    uint256 private balance;
    bool private locked;

    constructor() {
        owner = msg.sender;
        locked = false;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    receive() external payable {
        balance += msg.value;
    }

    modifier checkOwner() {
        require(msg.sender == owner, "Only owner can withdraw.");
        _;
    }

    modifier checkLockStatus() {
        require(!locked, "You can not withdraw right now.");
        locked = true;
        _;
        locked = false;
    }

    modifier checkBalance(uint256 _amount) {
        require(balance >= _amount, "Not enough balance.");
        _;
    }

    function withdraw(address payable _to, uint256 amount)
        public
        checkOwner
        checkLockStatus
        checkBalance(amount)
    {
        _to.transfer(amount);
        balance -= amount;
    }
}
