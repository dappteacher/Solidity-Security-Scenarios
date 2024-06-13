```markdown
# Solidity Security Scenarios

This repository contains two Solidity contracts demonstrating different security scenarios in smart contracts: 
`GuessTheHash` and `SecureHashGame`.

## GuessTheHash

The `GuessTheHash` contract is a guessing game where players can win 10 Ether by finding the correct string 
that hashes to the target hash. This contract demonstrates the vulnerability of front-running attacks in Ethereum transactions.

### How it Works

1. Alex deploys the `GuessTheHash` contract with 10 Ether.
2. Jacob discovers the correct string that hashes to the target hash ("Ethereum").
3. Jacob submits the solution by calling the `solve` function with "Ethereum" and sets a gas price of 15 gwei.
4. Mary monitors the transaction pool and sees Jacob's transaction.
5. Mary submits the same solution by calling `solve` with "Ethereum" and sets a higher gas price (100 gwei).
6. Due to the higher gas price, Mary's transaction is mined before Jacob's, and she wins the 10 Ether reward.

## SecureHashGame

The `SecureHashGame` contract demonstrates how to guard against front-running attacks using the commit-reveal scheme.

### How it Works

1. Alex deploys the `SecureHashGame` contract with 10 Ether.
2. Jacob discovers the correct string that hashes to the target hash ("Ethereum").
3. Jacob calculates the keccak256 hash of (address in lowercase + solution + secret).
4. Jacob commits the solution by calling `commitSolution` with the hash.
5. Mary monitors the transaction pool and sees Jacob's commit.
6. Mary submits the same commit with a higher gas price.
7. Mary's commit transaction is mined first, but she has not won the reward yet. She needs to call `revealSolution` with the correct solution and secret.
8. Jacob calls `revealSolution` with "Ethereum" and his secret.
9. Mary, monitoring the transaction pool, sees Jacob's reveal transaction and submits the same with a higher gas price.
10. Even if Mary's reveal transaction is mined first, it will revert because the `revealSolution` function checks the hash using keccak256(msg.sender + solution + secret).
11. Jacob's `revealSolution` passes the hash check, and he receives the 10 Ether reward.

## Getting Started

To use these contracts, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/dappteacher/Solidity-Security-Scenarios.git
    ```
2. Navigate to the respective contract directory:
    ```sh
    cd Solidity-Security-Scenarios/GuessTheHash
    # or
    cd Solidity-Security-Scenarios/SecureHashGame
    ```
3. Compile and deploy the contracts using your preferred development environment (e.g., Truffle, Hardhat, Remix).

### Example with Hardhat

1. Install Hardhat:
    ```sh
    npm install --save-dev hardhat
    ```
2. Create a Hardhat project:
    ```sh
    npx hardhat
    ```
3. Copy the contracts into the `contracts` directory of your Hardhat project.
4. Compile the contracts:
    ```sh
    npx hardhat compile
    ```
5. Deploy the contracts:
    ```sh
    npx hardhat run scripts/deploy.js
    ```

## Contributing

Contributions are welcome! If you have any suggestions or improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```

Feel free to modify the README as needed for your specific use case.
