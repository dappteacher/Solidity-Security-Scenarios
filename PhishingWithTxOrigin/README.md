# Phishing with `tx.origin` Vulnerability in Solidity

This folder contains Solidity contracts that demonstrate a phishing attack using the `tx.origin` variable and the solution to mitigate such attacks.

## Contents

- `Example.sol`
- `Example_Solution.sol`

## Contracts Overview

### Example.sol

This example demonstrates a phishing attack vulnerability by using the `tx.origin` variable to authenticate the owner of the contract. The `tx.origin` variable represents the original external account that initiated the transaction, which can be exploited by an attacker.

**Contracts:**
- **Victim**: A contract that allows the owner to transfer Ether to a specified address. The ownership check is done using `tx.origin`, which makes it vulnerable to phishing attacks.
- **Attack**: A contract that exploits the vulnerability in the Victim contract by initiating a transaction that tricks the Victim contract into thinking the attacker is the owner.

### Example_Solution.sol

This solution prevents the phishing attack by using `msg.sender` instead of `tx.origin` for ownership verification. The `msg.sender` variable represents the immediate sender of the message, which ensures that only direct calls from the owner are considered valid.

**Contracts:**
- **Save**: A safer version of the Victim contract where ownership is verified using `msg.sender`, thereby preventing phishing attacks.
- **Attack**: The attack contract remains the same, but it no longer succeeds in draining funds from the Save contract due to the improved ownership check.

## Author

- Yaghoub Adelzadeh
- GitHub: [dappteacher](https://www.github.com/dappteacher)

## License

This project is licensed under the MIT License.
