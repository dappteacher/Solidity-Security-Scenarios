```markdown
# Solidity Security Scenarios

This repository contains two Solidity contracts demonstrating different security scenarios in smart contracts: 
`GuessTheHash` and `SecureHashGame`.

## GuessTheHash

The `GuessTheHash` contract is a guessing game where players can win 10 Ether by finding the correct string 
that hashes to the target hash. This contract demonstrates the vulnerability of front-running attacks in Ethereum transactions.


## SecureHashGame

The `SecureHashGame` contract demonstrates how to guard against front-running attacks using the commit-reveal scheme.

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
