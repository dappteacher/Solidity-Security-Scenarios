// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

/// @title Roulette Game
/// @dev Roulette is a game where you can win all of the Ether in the contract
///      if you can submit a transaction at a specific timing. A player needs to
///      send 10 Ether and wins if the block.timestamp % 15 == 0.

/**
 * @notice Steps to play Roulette:
 * 1. Deploy Roulette with 10 Ether.
 * 2. Alex runs a powerful miner that can manipulate the block timestamp.
 * 3. Alex sets the block.timestamp to a number in the future that is divisible by
 *    15 and finds the target block hash.
 * 4. Alex's block is successfully included into the chain, Alex wins the
 *    Roulette game.
 */
contract Roulette {
    /// @notice Timestamp of the last spin
    uint256 public pastBlockTime;

    /// @dev Constructor, initializes the contract and allows it to receive Ether
    constructor() payable {}

    /// @notice Spin the Roulette
    /// @dev Players must send 10 Ether to play and only one transaction is allowed per block.
    ///      If the block timestamp is divisible by 15, the player wins all the Ether in the contract.
    function spin() external payable {
        require(msg.value == 10 ether, "Must send 10 Ether to play"); // must send 10 ether to play
        require(block.timestamp != pastBlockTime, "Only 1 transaction per block allowed"); // only 1 transaction per block

        pastBlockTime = block.timestamp;

        if (block.timestamp % 15 == 0) {
            (bool sent,) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }
}
/*
Vulnerability:
block.timestamp can be manipulated by miners with the following constraints
    * it cannot be stamped with an earlier time than its parent
    * it cannot be too far in the future
Preventative Techniques:
Don't use block.timestamp for a source of entropy and random number
*/
