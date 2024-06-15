// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

// Safe contract that securely handles Ether deposits and withdrawals
contract Safe {
    // Mapping to store the Ether balance of each address
    mapping(address => uint256) public balances;

    // Function to allow users to deposit Ether into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Function to allow users to withdraw their deposited Ether
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        // Preventing re-entrancy attacks by setting the balance to zero before transferring Ether
        balances[msg.sender] = 0;

        // Attempting to send the Ether back to the sender
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

// Attacker contract intended to exploit vulnerable contracts (Safe not defined in this file)
contract Attacker {
    // Instance of the Safe contract
    Safe public safe;

    // Constructor to initialize the safe contract with the provided address
    constructor(address _etherStoreAddress) {
        safe = Safe(_etherStoreAddress);
    }

    // Function to initiate the attack by depositing and then withdrawing Ether
    function attack() external payable {
        safe.deposit{value: msg.value}();
        safe.withdraw();
    }

    // Fallback function to continue withdrawing Ether as long as the safe contract has sufficient balance
    receive() external payable {
        if (address(safe).balance >= msg.value) {
            safe.withdraw();
        }
    }
}

/*
This Safe contract is designed to securely handle Ether deposits and withdrawals,
and it includes a fix to prevent re-entrancy attacks.

Here's a summary of the workflow:
1. Users can deposit Ether into the Safe contract using the deposit() function.
2. Users can withdraw their Ether using the withdraw() function.

In the Attacker contract, an instance of a vulnerable Safe contract is used.
The attack function in the Attacker contract demonstrates how an attacker might attempt to exploit
the Safe contract by initiating a withdrawal after making a deposit.

Note: The Safe contract is not vulnerable to re-entrancy attacks due to the proper handling of balance updates.
*/
