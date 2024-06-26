// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

/// @title WETH9 - A wrapped Ether (WETH) contract with permit functionality
/// @dev This contract allows users to wrap and unwrap Ether, 
///      and includes EIP-2612 permit functionality for gas-less approvals.
contract WETH9 is ERC20, ERC20Permit {

    /// @notice Constructor that initializes the WETH token with name and symbol
    constructor() ERC20("Wrapped Ether", "WETH") ERC20Permit("Wrapped Ether") {}

    /// @notice Fallback function to handle Ether deposits
    /// @dev This function is called when Ether is sent to the contract.
    receive() external payable {
        deposit();
    }

    /// @notice Deposits Ether into the contract and mints WETH to the sender's address
    /// @dev Mints WETH tokens equal to the amount of Ether sent.
    function deposit() public payable {
        _mint(msg.sender, msg.value);
    }

    /// @notice Withdraws Ether by burning WETH tokens
    /// @param wad The amount of WETH to burn and convert back to Ether
    /// @dev Burns the specified amount of WETH from the sender's balance and transfers Ether back to the sender.
    function withdraw(uint wad) public {
        require(balanceOf(msg.sender) >= wad, "Insufficient balance");
        _burn(msg.sender, wad);
        payable(msg.sender).transfer(wad);
    }
}
