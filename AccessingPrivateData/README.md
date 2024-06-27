# PD_Accessing

## Overview
This repository contains examples and demonstrations related to accessing and interpreting storage slots in a Solidity smart contract. The examples are designed to help understand how data is stored in Ethereum smart contracts and how to retrieve and manipulate this data using Web3.js and Ethers.js.

## Contents

### Smart Contracts
The repository includes a Solidity smart contract named `PD_Accessing.sol`, which demonstrates the allocation of storage slots in Solidity. The contract initializes several state variables and provides a constructor for setting their values.

### Web Pages
Two web pages demonstrate how to interact with the `PD_Accessing` smart contract using different JavaScript libraries:

1. **UsingWeb3.html**
   - Demonstrates how to use Web3.js to read storage slots from the `PD_Accessing` contract.
   - Initializes Web3 and connects to a local Ethereum node.
   - Reads and interprets the values stored in different storage slots and logs them to the console.

2. **UsingEtherJs.html**
   - Demonstrates how to use Ethers.js to read storage slots from the `PD_Accessing` contract.
   - Initializes Ethers.js and connects to a local Ethereum node.
   - Reads and interprets the values stored in different storage slots and logs them to the console.

## Getting Started

### Prerequisites
- Node.js
- An Ethereum node running locally (e.g., Ganache, Geth)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/dappteacher/your-repository-name.git
   cd your-repository-name
   ```

2. Deploy the `PD_Accessing` smart contract to your local Ethereum node. Make sure to note the deployed contract address.

3. Update the contract address in the JavaScript files of both `UsingWeb3.html` and `UsingEtherJs.html`:
   ```javascript
   var contractAddress = 'YOUR_DEPLOYED_CONTRACT_ADDRESS';
   ```

### Usage
1. Open `UsingWeb3.html` in a web browser to interact with the contract using Web3.js.
2. Open `UsingEtherJs.html` in a web browser to interact with the contract using Ethers.js.
3. Click the "Read Storage" button to fetch and log the storage values from the contract.

## Author
Yaghoub Adelzadeh

GitHub: [dappteacher](https://github.com/dappteacher)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
