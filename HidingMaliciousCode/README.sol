# Hiding Malicious Code in Solidity Contracts

This folder contains two examples of how malicious code can be hidden in Solidity smart contracts, 
demonstrating potential security vulnerabilities and how they can be exploited.

## Author

**Yaghoub Adelzadeh**  
GitHub: [dappteacher](https://www.github.com/dappteacher)

---

## Example 1: Event Misleading

### Overview

This example demonstrates how a malicious contract can emit misleading events, 
making it difficult to identify the true behavior of the contract.

### Contracts

#### Base.sol

A simple base contract with a logging function.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Base {
    event Log(string message);

    function log() public {
        emit Log("Base is called!");
    }
}
```

#### Caller.sol

A contract that interacts with the `Base` contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Caller {
    Base base;

    constructor(Base _base) {
        base = _base;
    }

    function log() public {
        base.log();
    }
}
```

#### Malicious.sol

A malicious contract that mimics the logging functionality of the `Base` contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Malicious {
    event Log(string message);

    function log() public {
        emit Log("Malicious is called!");
    }
}
```

### Explanation

The `Caller` contract is designed to interact with an instance of the `Base` contract. 
However, if a `Malicious` contract is passed to the `Caller` contract's constructor instead of the `Base` contract, 
the log function will call the log function of the `Malicious` contract, thereby emitting a misleading event. 
This demonstrates how an attacker could exploit the lack of type enforcement in the `Caller` contract to hide malicious behavior.

---

## Example 2: Hidden Malicious Behavior

### Overview

This example shows how a contract can include hidden malicious behavior in its functions, 
which can lead to unintended consequences and exploits.

### Contracts

#### Bank.sol

A simple bank contract that allows deposits and withdrawals of Ether.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Bank {
    function deposit() public payable {}

    function withdraw(address _receiver, uint256 _amount) public {
        (bool success,) = payable(_receiver).call{value: _amount}("");
        require(success, "Failed to send Ether!");
    }

    receive() external payable {}
}
```

#### Base.sol

A base contract that interacts with the `Bank` contract and includes a hidden malicious sendMoney function.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Base {
    address owner;
    Bank bank;

    constructor(Bank _bank) {
        bank = _bank;
        owner = msg.sender;
    }

    mapping(address => uint256) balances;

    function deposit() public payable {
        require(msg.value > 0, "Put the money!!");
        balances[msg.sender] += msg.value;

        (bool sent,) = address(bank).call{value: msg.value}("");
        require(sent, "Failed to send Ether!");
    }

    function sendMoney(address _receiver) public onlyOwner {
        uint256 amount = balances[_receiver];
        amount += 0.001 ether; // Malicious increment of 0.001 Ether
        bank.withdraw(_receiver, amount);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner");
        _;
    }
}
```

#### Scam.sol

A scam contract that mimics the functionality of the `Bank` contract but includes a hidden malicious withdrawal function.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Scam {
    function deposit() public payable {}

    function withdraw(address _receiver, uint256 _amount) public {
        _amount -= 100 wei; // Malicious reduction of 100 wei
        (bool success,) = payable(_receiver).call{value: _amount}("");
        require(success, "Failed to send Ether!");
    }

    receive() external payable {}
}
```

### Explanation

The `Base` contract includes a hidden malicious increment in the `sendMoney` function, 
which adds 0.001 Ether to the withdrawal amount. Similarly, the `Scam` contract reduces the withdrawal amount by 100 wei. 
These hidden behaviors can exploit users by making unauthorized changes to the transaction amounts, 
demonstrating how subtle code changes can lead to significant security vulnerabilities.

---

## Conclusion

These examples highlight the importance of thoroughly reviewing and testing smart contracts 
to identify and mitigate potential security risks. By understanding how malicious code can be hidden and exploited, 
developers can better protect their contracts and users from such attacks.

---

Feel free to reach out for any questions or further discussions on Solidity security scenarios.

---
