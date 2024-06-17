# SelfDestruct Vulnerability in Solidity

This folder contains Solidity contracts that demonstrate vulnerabilities related to the `selfdestruct` function and solutions to mitigate such vulnerabilities.

## Contents

- `Example1.sol`
- `Example1_Solution.sol`
- `Example2.sol`
- `Example2_Solution.sol`

## Contracts Overview

### Example1.sol

This example demonstrates how an attacker can exploit the `selfdestruct` function to take control of a contract and drain its funds. The `Victim` contract allows the owner to destroy the contract and send the remaining Ether to a specified address. However, it lacks proper access control on the `changeOwner` function.

**Contracts:**
- **Victim**: A contract that allows the owner to destroy the contract and transfer its balance. The lack of access control on the `changeOwner` function makes it vulnerable.
- **Attacker**: A contract that takes advantage of the vulnerability in the Victim contract to change the owner and destroy the contract, transferring its balance to the attacker.

### Example1_Solution.sol

This solution mitigates the vulnerability by adding an `onlyOwner` modifier to the `changeOwner` function, ensuring that only the current owner can change the ownership of the contract.

**Contracts:**
- **Victim**: The secure version of the contract that includes the `onlyOwner` modifier to prevent unauthorized ownership changes.
- **Attacker**: The same attacker contract, which can no longer exploit the `Victim` contract due to the improved access control.

### Example2.sol

This example demonstrates how an attacker can force a contract to reach a certain balance using `selfdestruct`, thereby disrupting the contract's intended functionality. The `Victim` contract has a game mechanism where the first user to reach a target balance wins a reward. The attacker can forcefully reach this balance by sending Ether directly to the contract via `selfdestruct`.

**Contracts:**
- **Victim**: A contract with a game mechanism where users deposit Ether, and the first to reach a target balance wins. The contract is vulnerable to forced Ether deposits via `selfdestruct`.
- **Attacker**: A contract that forces the balance of the Victim contract to a specific amount by using `selfdestruct`.

### Example2_Solution.sol

This solution prevents the attack by keeping an internal balance variable to track the deposited Ether, ensuring that only legitimate deposits count towards the target balance.

**Contracts:**
- **Victim**: The secure version of the contract that uses an internal balance variable to track deposits, preventing forced Ether deposits from counting towards the target balance.
- **Attacker**: The same attacker contract, which can no longer manipulate the balance of the Victim contract due to the improved balance tracking.

## Author

- Yaghoub Adelzadeh
- GitHub: [dappteacher](https://www.github.com/dappteacher)

## License

This project is licensed under the MIT License.
