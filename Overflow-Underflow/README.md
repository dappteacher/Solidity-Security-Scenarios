# TimeLock Smart Contract

This repository contains a Solidity smart contract `TimeLock` that implements a time-based lock on Ether deposits.

## Contract Details

- **Solidity Version**: ^0.7.6
- **License**: MIT
- **Author**: Yaghoub Adelzadeh
- **GitHub**: [dappteacher](https://www.github.com/dappteacher)

### TimeLock Contract

The `TimeLock` contract allows users to deposit Ether and withdraw it only after a specified time has passed.

#### Functions

- `deposit()`: Allows users to deposit Ether into the contract. The deposited Ether is locked for 30 days.
- `withdraw()`: Allows users to withdraw their deposited Ether if the lock time has expired.
- `increaseDeadline(uint256 _secondsToIncrease)`: Allows users to increase their lock time by `_secondsToIncrease` seconds.

#### Security Note

This contract has a known vulnerability where the lock time can be manipulated to allow early withdrawals. See the `Attack` contract for a demonstration.

### Attack Contract

The `Attack` contract demonstrates an exploit of the vulnerability in the `TimeLock` contract.

#### Functions

- `attack()`: Deposits Ether into the `TimeLock` contract, manipulates the lock time to allow for an early withdrawal, and then withdraws twice the deposited amount.

### How to Use

1. **Deploy the TimeLock Contract**: Deploy the `TimeLock` contract.
2. **Deploy the Attack Contract**: Deploy the `Attack` contract, passing the address of the deployed `TimeLock` contract to its constructor.
3. **Execute the Attack**: Call the `attack()` function on the `Attack` contract, providing Ether to simulate the attack.

### Testing

There are several ways to test the contracts:

- Use a local Ethereum blockchain with tools like Ganache.
- Use a testnet like Ropsten or Rinkeby.
- Use tools like Remix IDE for quick testing.

### Example

Deploy the contracts and execute the attack in Remix IDE:

1. Deploy the `TimeLock` contract.
2. Deploy the `Attack` contract, passing the address of the `TimeLock` contract to the constructor.
3. Fund the `Attack` contract with Ether.
4. Call the `attack()` function on the `Attack` contract.

### Disclaimer

This repository is for educational purposes only. Use at your own risk.

