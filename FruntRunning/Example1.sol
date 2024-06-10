// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

/*
Alex has created a guessing game where players can win 10 Ether by finding the correct string that hashes to the target hash. 
This contract demonstrates a vulnerability to front-running attacks.
*/

/*
1. Alex deploys the FindThisHash contract with 10 Ether.
2. Jacob discovers the correct string that hashes to the target hash ("Ethereum").
3. Jacob submits the solution by calling the solve function with "Ethereum" and sets a gas price of 15 gwei.
4. Mary monitors the transaction pool for submitted answers.
5. Mary observes Jacob's transaction and submits the same solution with a higher gas price (100 gwei).
6. Due to the higher gas price, Mary's transaction is mined before Jacob's.
   As a result, Mary wins the 10 Ether reward.

Explanation:
Transactions require some time to be mined and are temporarily placed in the transaction pool.
Transactions with higher gas prices are usually prioritized and mined first.
An attacker can exploit this by observing the transaction pool, submitting the same solution with a higher gas price, and having their transaction mined before the original.
*/

contract FindThisHash {
    // The hash that players need to match by finding the correct string.
    bytes32 public constant hash = 
        0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    // Constructor to accept initial funding of 10 Ether.
    constructor() payable {}

    // Function to solve the puzzle. If the correct solution is provided, the sender wins 10 Ether.
    function solve(string memory _solution) public {
        // Check if the provided solution matches the target hash.
        require(
            hash == keccak256(abi.encodePacked(_solution)), "Incorrect answer"
        );

        // Send 10 Ether to the sender if the solution is correct.
        (bool sent,) = msg.sender.call{value: 10 ether}("");
        require(sent, "Failed to send Ether");
    }
}

