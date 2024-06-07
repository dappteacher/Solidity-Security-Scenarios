// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Victim {
    bool locked;
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    // We can prevent the attack by adding a simple modifier!

    function withdraw() public noReentrant{
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }
    
    modifier noReentrant{
        require(locked == false,"No Reentrant");
        locked = true;
        _;
        locked = false;
    }
}

contract Attacker {
    Victim public victim;

    constructor(address _etherStoreAddress) {
        victim = Victim(_etherStoreAddress);
    }

    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withdraw();
    }

    receive() external payable {
        if (address(victim).balance >= msg.value) {
            victim.withdraw();
        }
    }
}


