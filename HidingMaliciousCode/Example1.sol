// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

// Base contract with a simple logging functionality
contract Base {
    event Log(string message); // Event declaration

    // Function to emit the log event
    function log() public {
        emit Log("Base is called!");
    }
}

// Caller contract that interacts with the Base contract
contract Caller {
    Base base; // State variable to hold the instance of the Base contract

    // Constructor that initializes the base contract instance
    constructor(Base _base) {
        base = _base;
    }

    // Function that calls the log function of the Base contract
    function log() public {
        base.log();
    }
}

// Malicious contract with similar logging functionality to Base
contract Malicious {
    event Log(string message); // Event declaration

    // Function to emit the log event with a different message
    function log() public {
        emit Log("Malicious is called!");
    }
}

/*
 * Explanation of potential malicious behavior:
 *
 * The Caller contract is designed to interact with an instance of the Base contract.
 * However, if a Malicious contract is passed to the Caller contract's constructor 
 * instead of the Base contract, the log function will call the log function of 
 * the Malicious contract, thereby emitting a misleading event.
 *
 * The key vulnerability lies in the fact that the Caller contract does not enforce 
 * the type of the contract being passed in. An attacker could deploy a Malicious 
 * contract with the same interface (log function) as the Base contract and then 
 * pass this malicious contract to the Caller contract.
 *
 * This can be exploited to hide malicious behavior, as the emitted event from the 
 * Malicious contract would not indicate the intended functionality of the Base 
 * contract.
 */

