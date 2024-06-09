// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
   This contract demonstrates how to guard against front-running attacks using the commit-reveal scheme.
*/

/*
1. Alex deploys the SecuredFindThisHash contract with 10 Ether.
2. Jacob discovers the correct string that hashes to the target hash ("Ethereum").
3. Jacob calculates the keccak256 hash of (address in lowercase + solution + secret), where:
   - Address is his wallet address in lowercase
   - Solution is "Ethereum"
   - Secret is a password known only to Jacob (e.g., "mysecret")
   keccak256("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266Ethereummysecret") = 
   '0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36'
4. Jacob commits the solution by calling commitSolution("0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36") with a gas price of 15 gwei.
5. Mary monitors the transaction pool and sees Jacob's commit.
6. Mary submits the same commit by calling commitSolution("0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36") with a higher gas price (100 gwei).
7. Mary's commit transaction is mined before Jacob's, but she has not won the reward yet. She needs to call revealSolution() with the correct solution and secret.
8. Jacob calls revealSolution("Ethereum", "mysecret") with a gas price of 15 gwei.
9. Mary, still monitoring the transaction pool, sees Jacob's reveal transaction and submits revealSolution("Ethereum", "mysecret") with a higher gas price (100 gwei).
10. Even if Mary's reveal transaction is mined first, it will revert with "Hash doesn't match" because the revealSolution() function checks the hash using keccak256(msg.sender + solution + secret).
11. Jacob's revealSolution("Ethereum", "mysecret") passes the hash check, and he receives the 10 Ether reward.
*/

contract SecuredFindThisHash {
    // Struct to store commit details
    struct Commit {
        bytes32 solutionHash;
        uint256 commitTime;
        bool revealed;
    }

    // The target hash that needs to be solved
    bytes32 public hash =
        0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    // Address of the winner
    address public winner;

    // Reward amount
    uint256 public reward;

    // Status of the game
    bool public ended;

    // Mapping to store commit details by address
    mapping(address => Commit) commits;

    // Modifier to check if the game is active
    modifier gameActive() {
        require(!ended, "Game has already ended");
        _;
    }

    // Constructor to initialize the contract with the reward amount
    constructor() payable {
        reward = msg.value;
    }

    /* 
       Function to commit the solution hash.
       The hash is calculated using keccak256(address in lowercase + solution + secret).
       Each user can only commit once, and the game must be active.
    */
    function commitSolution(bytes32 _solutionHash) public gameActive {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime == 0, "Solution already committed");
        commit.solutionHash = _solutionHash;
        commit.commitTime = block.timestamp;
        commit.revealed = false;
    }

    /* 
        Function to get the details of a user's commit.
        Returns the solution hash, commit time, and reveal status.
        The game must be active, and the user must have committed a solution hash.
    */
    function getMySolution()
        public
        view
        gameActive
        returns (bytes32, uint256, bool)
    {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime != 0, "Solution not yet committed");
        return (commit.solutionHash, commit.commitTime, commit.revealed);
    }

    /* 
        Function to reveal the committed solution and claim the reward.
        The game must be active, and the user must have committed a solution hash.
        The solution hash is verified using keccak256(msg.sender + solution + secret).
        If the hash matches and the solution is correct, the user is declared the winner, the game ends, and the reward is sent to the winner.
    */
    function revealSolution(string memory _solution, string memory _secret)
        public
        gameActive
    {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime != 0, "Solution not yet committed");
        require(
            commit.commitTime < block.timestamp,
            "Cannot reveal in the same block"
        );
        require(!commit.revealed, "Solution already revealed");

        bytes32 solutionHash =
            keccak256(abi.encodePacked(msg.sender, _solution, _secret));
        require(solutionHash == commit.solutionHash, "Hash doesn't match");

        require(
            keccak256(abi.encodePacked(_solution)) == hash, "Incorrect answer"
        );

        winner = msg.sender;
        ended = true;

        (bool sent,) = payable(msg.sender).call{value: reward}("");
        if (!sent) {
            winner = address(0);
            ended = false;
            revert("Failed to send Ether");
        }
    }
}
