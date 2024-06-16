```markdown
# Honeypot Attack Demonstration

This folder contains Solidity smart contracts demonstrating a honeypot attack and the reentrancy vulnerability in Ethereum smart contracts.

## Contracts

### 1. Bank.sol

#### Overview
This contract allows users to deposit and withdraw Ether. It logs the transactions using a separate `Logger` contract.

#### Vulnerability Demonstration Steps

1. **Deployment**: Deploy the `Bank` contract with the address of the `Logger` contract.
2. **Deposit Ether**: Users can deposit Ether into the `Bank` contract.
3. **Withdraw Ether**: Users can withdraw their deposited Ether.

#### Vulnerability
The `Bank` contract is vulnerable to a reentrancy attack because it updates the user's balance after sending Ether. An attacker can exploit this by recursively calling the `withdraw` function before the balance is updated.

### 2. Logger.sol

#### Overview
This contract logs the deposit and withdrawal actions of users interacting with the `Bank` contract.

### 3. Attack.sol

#### Overview
This contract attempts to exploit the reentrancy vulnerability in the `Bank` contract.

#### Attack Demonstration Steps

1. **Deployment**: Deploy the `Attack` contract with the address of the `Bank` contract.
2. **Initiate Attack**: Call the `attack` function with some Ether.
3. **Reentrancy**: The `receive` function in the `Attack` contract recursively calls the `withdraw` function of the `Bank` contract, draining its funds.

### 4. HoneyPot.sol

#### Overview
This contract serves as a trap for attackers by reverting transactions with specific actions.

#### Mitigation Demonstration Steps

1. **Deployment**: Deploy the `HoneyPot` contract.
2. **Set Logger**: Use the `HoneyPot` contract as the logger in the `Bank` contract.
3. **Attempt Attack**: An attacker trying to exploit the reentrancy vulnerability will have their transaction reverted when attempting to withdraw funds, as the `log` function in the `HoneyPot` contract will revert the transaction.

## Author

- **Yaghoub Adelzadeh**
  - GitHub: [dappteacher](https://www.github.com/dappteacher)

## License

These contracts are licensed under the MIT License.
```
