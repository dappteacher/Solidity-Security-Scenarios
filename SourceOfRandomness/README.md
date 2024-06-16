# Victim and Attack Contracts

This repository contains two Solidity contracts: `Victim` and `Attack`. The `Victim` contract is vulnerable to a predictable randomness attack, which is exploited by the `Attack` contract.

## Contract Details

- **Solidity Version**: ^0.8.25
- **License**: MIT
- **Author**: Yaghoub Adelzadeh
- **GitHub**: [dappteacher](https://www.github.com/dappteacher)

### Victim Contract

The `Victim` contract allows users to guess a number. If the guessed number matches a randomly generated number, the user receives 1 Ether.

#### Functions

- `constructor() payable`: Constructor function that allows the contract to receive Ether during deployment.
- `guess(uint256 _guess)`: Function where users can guess a number. If `_guess` matches a randomly generated `answer`, the caller receives 1 Ether.

#### Security Note

This contract uses `blockhash` and `block.timestamp` as a source of randomness, which is predictable and exploitable. This is a known security vulnerability.

### Attack Contract

The `Attack` contract exploits the predictable randomness vulnerability in the `Victim` contract.

#### Functions

- `attack(Victim _victim)`: Initiates an attack on the `Victim` contract by predicting the answer and calling the `guess` function on the `_victim` contract.

#### Security Note

This contract demonstrates how an attacker can predict the answer to the `Victim` contract's `guess` function and claim the reward.

### How to Use

1. **Deploy the Victim Contract**: Deploy the `Victim` contract.
2. **Deploy the Attack Contract**: Deploy the `Attack` contract, passing the address of the deployed `Victim` contract to its `attack` function.
3. **Execute the Attack**: Call the `attack` function on the `Attack` contract to exploit the vulnerability in the `Victim` contract.

### Testing

There are several ways to test the contracts:

- Use a local Ethereum blockchain with tools like Ganache.
- Use a testnet like Ropsten or Rinkeby.
- Use tools like Remix IDE for quick testing.

### Example

Deploy the contracts and execute the attack in Remix IDE:

1. Deploy the `Victim` contract.
2. Deploy the `Attack` contract, passing the address of the `Victim` contract to the `attack` function.
3. Fund the `Attack` contract with Ether.
4. Call the `attack()` function on the `Attack` contract.

### Disclaimer

This repository is for educational purposes only. Use at your own risk.

