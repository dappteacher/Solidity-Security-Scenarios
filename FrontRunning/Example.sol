// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

/*
This contract is a guessing game where players can win 10 Ether by finding the correct string that hashes to the target hash.
It highlights the vulnerability of front-running attacks in Ethereum transactions.
*/

/*
Steps to illustrate the front-running vulnerability:

1. Alex deploys the GuessTheHash contract with 10 Ether.
2. Jacob discovers the correct string that hashes to the target hash ("Ethereum").
3. Jacob submits the solution by calling the solve function with "Ethereum" and sets a gas price of 15 gwei.
4. Mary monitors the transaction pool for submitted answers.
5. Mary sees Jacob's transaction and submits the same solution with a higher gas price (100 gwei).
6. Because of the higher gas price, Mary's transaction gets mined before Jacob's.
   Consequently, Mary wins the 10 Ether reward.

Explanation:
Transactions are temporarily placed in the transaction pool before being mined.
Transactions with higher gas prices are prioritized and mined first.
An attacker can exploit this by observing the transaction pool, submitting the same solution with a higher gas price, and having their transaction mined before the original one.
*/

contract GuessTheHash {
    // The target hash that players need to match by finding the correct string.
    bytes32 public constant targetHash = 
        0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    // Constructor to accept initial funding of 10 Ether.
    constructor() payable {
        require(msg.value == 10 ether, "Contract must be initialized with 10 Ether");
    }

    // Function to solve the puzzle. If the correct solution is provided, the sender wins 10 Ether.
    function solve(string memory solution) public {
        // Check if the provided solution matches the target hash.
        require(
            targetHash == keccak256(abi.encodePacked(solution)), "Incorrect solution"
        );

        // Send 10 Ether to the sender if the solution is correct.
        (bool sent, ) = msg.sender.call{value: 10 ether}("");
        require(sent, "Failed to send Ether");
    }
}
