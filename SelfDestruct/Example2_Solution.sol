//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Victim{
    uint256 public targetAmount = 7 ether;
    address public winner;
    uint256 balance;

    function deposit() public payable {
        require(msg.value == 1 ether,"You can only send 1 Ether");
        // We can prevent the attack with adding this line
        balance += msg.value;
        
        require(balance <= targetAmount,"Game is Over");

        if(balance == targetAmount){
            winner = msg.sender;
        }
        
    }
    function claimReward()public {
        require(msg.sender == winner,"You are not winner!");
        (bool sent,)=msg.sender.call{value:address(this).balance}("");
        require(sent,"Failed!");
    }
}
contract Attacker{
    Victim victim;
    constructor(Victim _victim){
        victim = Victim(_victim);
    }
    function attack()public payable {
        address payable myAddress = payable(address(victim));
        selfdestruct(myAddress);
    }
}
