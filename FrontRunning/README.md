# FrontRunning

This folder contains two Solidity smart contracts demonstrating the concept of front-running attacks and a mitigation strategy using the commit-reveal scheme.

## Contracts

### 1. [Example.sol](./Example.sol)

#### Overview
This contract is a guessing game where players can win 10 Ether by finding the correct string that hashes to the target hash. It highlights the vulnerability of front-running attacks in Ethereum transactions.

#### Vulnerability Demonstration Steps

1. **Deployment**: Alex deploys the `GuessTheHash` contract with 10 Ether.
2. **Solution Discovery**: Jacob discovers the correct string that hashes to the target hash ("Ethereum").
3. **Submission**: Jacob submits the solution by calling the `solve` function with "Ethereum" and sets a gas price of 15 gwei.
4. **Monitoring**: Mary monitors the transaction pool for submitted answers.
5. **Front-Running**: Mary sees Jacob's transaction and submits the same solution with a higher gas price (100 gwei).
6. **Result**: Because of the higher gas price, Mary's transaction gets mined before Jacob's, and Mary wins the 10 Ether reward.

#### Explanation
Transactions with higher gas prices are prioritized and mined first. An attacker can exploit this by observing the transaction pool, submitting the same solution with a higher gas price, and having their transaction mined before the original one.

### 2. [Example_Solution.sol](./Example_Solution.sol)

#### Overview
This contract demonstrates how to guard against front-running attacks using the commit-reveal scheme.

#### Mitigation Demonstration Steps

1. **Deployment**: Alex deploys the `SecureHashGame` contract with 10 Ether.
2. **Solution Discovery**: Jacob discovers the correct string that hashes to the target hash ("Ethereum").
3. **Commit Hash Calculation**: Jacob calculates the keccak256 hash of (address + solution + secret).
4. **Commit Submission**: Jacob commits the solution by calling `commitSolution` with the calculated hash and a gas price of 15 gwei.
5. **Monitoring**: Mary monitors the transaction pool and sees Jacob's commit.
6. **Front-Running Attempt**: Mary submits the same commit with a higher gas price (100 gwei).
7. **Reveal Attempt**: Mary tries to reveal the solution but fails as the commit hash check fails.
8. **Reveal Success**: Jacob successfully reveals the solution and wins the 10 Ether reward.

#### Explanation
Using the commit-reveal scheme, even if an attacker sees the commit transaction and tries to front-run, they cannot successfully reveal the solution without knowing the secret, ensuring that only the original solver can win the reward.

## Author

- **Yaghoub Adelzadeh**
  - GitHub: [dappteacher](https://www.github.com/dappteacher)

## License

These contracts are licensed under the MIT License.
