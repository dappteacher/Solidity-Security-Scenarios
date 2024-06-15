// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

contract Safe {
    // State variable to track re-entrancy status
    bool locked;

    // Mapping to store the Ether balance of each address
    mapping(address => uint256) public balances;

    // Function to allow users to deposit Ether into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Function to allow users to withdraw their deposited Ether
    // Uses a modifier to prevent re-entrancy attacks
    function withdraw() public noReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        // Attempting to send the Ether back to the sender
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        // Setting the balance to zero after successful transfer
        balances[msg.sender] = 0;
    }

    // Modifier to prevent re-entrancy attacks
    modifier noReentrant {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}

contract FailedAttacker {
    // Instance of the Safe contract
    Safe public safe;

    // Constructor to initialize the Safe contract with the provided address
    constructor(address _etherStoreAddress) {
        safe = Safe(_etherStoreAddress);
    }

    // Function to initiate the attack by depositing and then attempting to withdraw Ether
    function attack() external payable {
        safe.deposit{value: msg.value}();
        safe.withdraw();
    }

    // Fallback function to continue withdrawing Ether as long as the Safe contract has sufficient balance
    receive() external payable {
        if (address(safe).balance >= msg.value) {
            safe.withdraw();
        }
    }
}

/*
The Safe contract securely handles Ether deposits and withdrawals, preventing re-entrancy attacks using a modifier.

Key components:
1. deposit() - Allows users to deposit Ether into the contract.
2. withdraw() - Allows users to withdraw their Ether, protected by the noReentrant modifier to prevent re-entrancy attacks.
3. noReentrant modifier - Ensures that no re-entrant calls can be made to the withdraw function.

In the FailedAttacker contract, an instance of the Safe contract is used to demonstrate that re-entrancy attacks are not possible
due to the protection offered by the noReentrant modifier.
*/
