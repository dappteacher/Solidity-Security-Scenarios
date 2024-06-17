# Denial of Service (DoS) Vulnerabilities in Solidity

This folder contains Solidity contracts demonstrating and mitigating Denial of Service (DoS) attacks. 
The contracts illustrate common patterns of DoS vulnerabilities and their corresponding solutions.

## Contents

- `Example1.sol`
- `Example1_Solution.sol`
- `Example2.sol`
- `Example2_Solution.sol`

## Contracts Overview

### Example1.sol

This example demonstrates a Denial of Service attack using a contract that manages a "king of the hill" game.

**Contracts:**
- **Victim**: 
    A contract where users can claim the throne by sending more Ether than the current king.
- **Attack**: 
    A contract that exploits the vulnerability by not having a fallback or receive function, 
    causing the Victim contract to fail when trying to send Ether back to the previous king.


### Example1_Solution.sol

This solution prevents the Denial of Service attack by using a mapping to store balances, 
allowing previous kings to withdraw their balances at their convenience.

**Contracts:**
- **Safe**: 
    A safer version of the Victim contract where balances are stored in a mapping, 
    and previous kings can withdraw their balances.
- **Attack**: 
    The attack contract remains the same, but it no longer causes a DoS.


### Example2.sol

This example demonstrates a Denial of Service attack in a reward distribution contract.

**Contracts:**
- **RewardDistribution**: 
    A contract where users can participate by sending 1 Ether, and the owner can distribute rewards.
- **DOSAttack**: 
    A contract that participates in the RewardDistribution contract and causes a DoS by reverting any attempts to send Ether back.


### Example2_Solution.sol

This solution prevents the Denial of Service attack by allowing participants to withdraw their rewards individually instead of 
    sending Ether directly from the contract.

**Contracts:**
- **SafeRewardDistribution**: 
    A safer version of the RewardDistribution contract where rewards are stored in a mapping, 
    and participants can withdraw their rewards individually.
- **SafeAttack**: The attack contract remains the same, but it no longer causes a DoS.



## Author

- Yaghoub Adelzadeh
- GitHub: [dappteacher](https://www.github.com/dappteacher)

## License

This project is licensed under the MIT License.
