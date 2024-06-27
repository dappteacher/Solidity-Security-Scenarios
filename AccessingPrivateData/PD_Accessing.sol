// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.15;

/**
 * @title PD_Accessing
 * @dev Demonstrates storage slot allocation in Solidity
 *
 * # Storage
 * - 2 ** 256 slots
 * - 32 bytes for each slot
 * - Data is stored sequentially in the order of declaration
 * - Storage is optimized to save space. If neighboring variables fit in a single
 *   32 bytes, then they are packed into the same slot, starting from the right
 */
contract PD_Accessing {
    // Slot 0
    uint256 private bigNumber;

    // Slot 1
    bytes32 private pass;
    
    // Slot 2
    bool private flag = true;
    uint248 private shorterNumber;

    // Beginning from slot 3 (Depends on the length)
    address[2] private operators;

    /**
     * @dev Constructor that initializes the contract's state variables
     * @param _bigNumber Initial value for bigNumber
     * @param _pass Initial value for pass
     * @param _shorterNumber Initial value for shorterNumber
     * @param _operators Initial value for operators array
     */
    constructor(uint256 _bigNumber, bytes32 _pass, uint248 _shorterNumber, address[2] memory _operators) {
        bigNumber = _bigNumber;
        pass = _pass;
        shorterNumber = _shorterNumber;
        operators = _operators;
    }
}
