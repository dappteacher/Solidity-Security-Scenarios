//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Save{
    address public owner;
    // Constructor to set the contract deployer as the owner and accept initial ether
    constructor()payable {
        owner = msg.sender;
    }
    // Function to transfer ether to a specified address
    function transfer(address payable _to, uint256 _amount)public {
        // Ensuring the caller is the owner of the contract
        require(msg.sender == owner,"Not Owner!");

        // Attempting to send the specified amount of ether
        (bool sent,) = _to.call{value: _amount}("");
        require(sent,"Failed to send Ether!");
    }
    // Function to get the contract's ether balance
    function getBalance()public view returns (uint256){
        return(address(this).balance);
    }    
}
// Attack contract attempting to drain the Save contract
contract Attack{
    address payable public owner;
    Save save;
    // Constructor to set the target Save contract and the owner of the Attack contract
    constructor(Save _save){
        save = Save(_save);
        owner = payable (msg.sender);
    }
    // Function to initiate the attack
    function attack()public {
        // Attempting to transfer all ether from the Save contract to the owner of the Attack contract
        save.transfer(owner, address(save).balance);
    }
}

// We can prevent the previous phishing attack by using msg.sender instead of tx.origin
