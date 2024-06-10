//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Victim{
    address private owner;
    constructor(){
        owner = msg.sender;
    }
    function deposit()public payable {}

    function destroyContract(address payable _to)public{
        require(msg.sender == owner,"Only owner can destroy the contract");
        selfdestruct(_to);
    } 
    // We can prevent the attack with adding onlyOwner modifier 
    function changeOwner(address _newOwner)public onlyOwner{
        owner = _newOwner;
    }   
    receive() external payable { }
    modifier onlyOwner{
        require(msg.sender == owner,"Only Owner!");
        _;
    }
}

contract Attacker{
    Victim public victim;
    constructor(address payable _victim){
        victim = Victim(_victim);
    }
    function attack()public {
        victim.changeOwner(address(this));
        victim.destroyContract(payable (address(this)));
    }
}
