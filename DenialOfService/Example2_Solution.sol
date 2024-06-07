// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract SafeRewardDistribution {
    address public owner;
    address[] public participants;
    mapping(address => uint256) public rewards;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Access is denied!");
        _;
    }

    // Allows a user to participate by sending exactly 1 ether
    function participate() public payable {
        require(msg.value == 1 ether, "Must send exactly 1 ether to participate");
        participants.push(msg.sender);
        rewards[msg.sender] += 1.001 ether; // Set the reward amount for each participant
    }

    // Owner allocates rewards to all participants but does not transfer Ether directly
    function distributeRewards() public onlyOwner {
        for (uint256 i = 0; i < participants.length; i++) {
            address participant = participants[i];
            rewards[participant] += 1.001 ether; // Set the reward amount for each participant
        }
    }

    // Allows participants to withdraw their rewards individually
    function withdraw() public {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to withdraw");

        rewards[msg.sender] = 0; // Reset the reward balance before transferring to avoid re-entrancy
        (bool sent, ) = msg.sender.call{value: reward}("");
        require(sent, "Failed to send Ether!");
    }

    // Fallback function to receive Ether
    receive() external payable {}
}

contract SafeAttack {
    SafeRewardDistribution victim;

    // Initialize the SafeAttack contract with the address of the SafeRewardDistribution contract
    constructor(SafeRewardDistribution _victim) {
        victim = SafeRewardDistribution(_victim);
    }

    // Fallback function to reject Ether and revert the transaction
    receive() external payable {
        revert("No Ether Accepted!");
    }

    // Function to participate in the SafeRewardDistribution contract by sending Ether
    function attack() public payable {
        victim.participate{value: msg.value}();
    }
}
