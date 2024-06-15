# Re-Entrancy Vulnerability and Mitigation

This folder contains Solidity contracts that demonstrate the re-entrancy vulnerability and how to mitigate it. 
The examples include a vulnerable contract, a safe contract with a simple fix, and another safe contract 
with a re-entrancy guard using a modifier.

## Explanation

### Re-Entrancy Attack

A re-entrancy attack occurs when an attacker repeatedly calls a vulnerable function (such as `withdraw`) 
before the previous invocation of the function has completed. 
This is usually done by exploiting external calls that invoke fallback functions.

### Preventing Re-Entrancy Attacks

1. **State Updates Before External Calls:**
   - Update the contract’s state before making any external calls.
   - In `First_Solution.sol`, the balance is set to zero before transferring Ether.

2. **Re-Entrancy Guard:**
   - Use a state variable and a modifier to ensure that functions cannot be re-entered.
   - In `Second_Solution.sol`, the `noReentrant` modifier prevents the `withdraw` function from being re-entered.

## Summary

- `Example.sol` demonstrates a vulnerable contract and an attacker exploiting it.
- `First_Solution.sol` shows a simple fix by updating the state before making external calls.
- `Second_Solution.sol` provides a robust solution using a re-entrancy guard.

These examples highlight the importance of securing smart contracts against re-entrancy attacks to ensure the safe handling 
of Ether deposits and withdrawals.
