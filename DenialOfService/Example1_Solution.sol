//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Safe{
    address public king;
    uint256 public balance;
    mapping(address => uint256)public balances;

    // Claim the throne by sending more Ether than the current balance
    function claimThrone()public payable {
        require(msg.value > balance,"Need to pay more to become the king");

        // Add the current balance to the previous king's balance
        balances[king] += balance;

        // Update the balance to the new value sent by the new king
        balance = msg.value;

        // Update the king to the new claimant
        king = msg.sender;
    }
    //Previous kings can withdraw their balances
    function withdraw()public {
        // Ensure the current king cannot withdraw their own balance
        require(msg.sender != king,"Current king cannot withdraw");

        // Retrieve the balance of the sender
        uint256 amount = balances[msg.sender];

        // Reset the sender's balance to 0
        balances[msg.sender] = 0;

        // Send the Ether to the sender
        (bool sent,)= msg.sender.call{value: amount}("");
        require(sent,"Failed to send Ether!");
    }
    // Function to check the balance of a specific account
    function balanceof(address _account)public view returns(uint256){
        return(balances[_account]);
    }
}
contract Attack{
    Safe safe;

    // Initialize the Attack contract with the address of the Safe contract
    constructor(Safe _temp){
        safe = Safe(_temp);
    }
    // Function to attack and claim the throne by sending Ether to the Safe contract
    function attack()public payable {
        safe.claimThrone{value:msg.value}();
    }
}
