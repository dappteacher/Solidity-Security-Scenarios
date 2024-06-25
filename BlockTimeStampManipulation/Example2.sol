// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

/// @title Timestamp Lottery Game
/// @dev A simple lottery game where players win if the last digit of the block timestamp is 7.

contract TimestampLottery {
    /// @notice The amount required to play the lottery
    uint256 public constant TICKET_PRICE = 1 ether;

    /// @dev Constructor, initializes the contract and allows it to receive Ether
    constructor() payable {}

    /// @notice Play the lottery game
    /// @dev Players must send exactly 1 Ether to play. If the last digit of the block timestamp is 7,
    ///      the player wins the entire balance of the contract.
    function play() external payable {
        require(msg.value == TICKET_PRICE, "Must send exactly 1 Ether to play");

        // Check if the last digit of the block timestamp is 7
        if (block.timestamp % 10 == 7) {
            (bool sent,) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }
}
/*
### Explanation

1. **Ticket Price**: 
  Players must send exactly 1 Ether to play the lottery.
2. **Winning Condition**: 
  The player wins the entire balance of the contract if the last digit of the `block.timestamp` is 7.

### Vulnerability

The vulnerability lies in the use of `block.timestamp % 10 == 7` as a winning condition. 
A malicious miner could manipulate the block timestamp to increase the chances of winning. Here's how:

1. **Timestamp Manipulation**: 
  A miner with sufficient control over the block timestamp can try multiple block timestamps ending in 7.
2. **High Probability of Winning**: 
  By setting the timestamp to a future time ending in 7, the miner can ensure they meet the winning condition 
  and drain the contract's balance.

### Steps to Exploit

1. **Deploy the Contract**: 
  Deploy the `TimestampLottery` contract with some initial Ether.
2. **Manipulate Timestamp**: 
  A malicious miner submits a transaction to play the lottery and manipulates the block timestamp to end in 7.
3. **Win the Lottery**: 
  The transaction is included in the block, and the miner wins the entire balance of the contract.

This example demonstrates how using `block.timestamp` for critical game logic can lead to vulnerabilities. 
It's important to avoid relying on `block.timestamp` for security-sensitive operations in smart contracts.
*/
