# Delegate-call Attack Examples

This repository contains Solidity smart contracts that demonstrate the delegatecall vulnerability and an attack contract exploiting this vulnerability.

## Overview

Solidity smart contracts can call functions from other contracts using different methods, such as `call`, `delegatecall`, and `staticcall`. Each method has different implications for state variables, security, and gas usage. 

### Delegatecall

`delegatecall` is a low-level Solidity function that allows one contract to execute code from another contract while maintaining the calling contract's storage context. This can lead to unexpected behaviors and vulnerabilities if not used carefully.

## Example 1: First and Second Contracts

### Contract First

Simple contract to set an owner address.

- **Functionality**: Sets the owner address to the caller's address.
- **Function**: `setOwner()`
- **Visibility**: Public
- **State Variable**:
  - `owner`: Address of the owner

### Contract Second

Contract that interacts with contract First using `delegatecall`.

- **Constructor**: Initializes with the address of contract First.
- **Fallback Function**: Delegates calls to contract First.
- **State Variables**:
  - `owner`: Address of the owner
  - `first`: Instance of contract First

### Contract Attack

Contract to demonstrate an attack by calling `setOwner()` on contract Second.

- **Constructor**: Sets the address of contract Second.
- **Function**: `attack()`
- **Attack Method**: Calls `setOwner()` on contract Second using `call()`

### Vulnerability

The attack exploits the delegatecall in contract Second's fallback function, allowing anyone to call functions from contract First as if they were executing in the context of contract Second. This means the `setOwner()` function in contract First can be called by anyone through contract Second's fallback function.

## Example 2: First and Second Contracts

### Contract First

Simple contract to store and retrieve a number.

- **Functionality**: Sets and retrieves a stored number.
- **Function**: `setNumber(uint256)`
- **Visibility**: Public
- **State Variable**:
  - `number`: Stored number

### Contract Second

Contract that interacts with contract First using `delegatecall`.

- **Constructor**: Initializes with the address of contract First and sets owner.
- **Function**: `setNumber(uint256)`
- **Visibility**: Public
- **State Variables**:
  - `owner`: Address of the owner
  - `first`: Instance of contract First

### Contract Attack

Contract to demonstrate an attack by calling `setNumber()` on contract Second.

- **Constructor**: Sets the address of contract Second.
- **Functions**:
  - `setNumber(uint256)`: Sets the `number` variable in the Attack contract.
  - `attack()`: Performs the attack by setting the `number` variable in contract Second to the address of the Attack contract and then to 3.

### Vulnerability

The attack exploits the delegatecall in contract Second's `setNumber()` function, which calls contract First's `setNumber()` function. This means that by calling `setNumber()` on contract Second, the Attack contract can manipulate the `number` variable of contract First as if it were acting directly on contract Second.

---

### Disclaimer

These contracts are purely for educational purposes to demonstrate the delegatecall vulnerability. Do not use delegatecall in scenarios where you expect the contract to protect sensitive data or perform authorization checks.

---

## Author

**Yaghoub Adelzadeh**

- **GitHub**: [dappteacher](https://www.github.com/dappteacher)
- **License**: MIT
