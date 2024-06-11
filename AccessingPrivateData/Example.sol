// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.24;

/*
Note: Use the contract deployed on Goerli for testing due to limitations with JVM and old Web3 versions in browsers.
Contract deployed on Goerli: 0x534E4Ce0ffF779513793cfd70308AF195827BD31
*/

/*
# Storage Layout
- 2 ** 256 slots available
- Each slot is 32 bytes
- Data is stored sequentially in the order of declaration
- Storage is optimized to save space by packing neighboring variables into the same slot if they fit within 32 bytes
*/

contract Vault {
    // slot 0
    uint256 public itemCount = 123;

    // slot 1
    address public contractOwner = msg.sender;
    bool public statusFlag = true;
    uint16 public shortNumber = 31;

    // slot 2
    bytes32 private secretKey;

    // Constants do not use storage slots
    uint256 public constant fixedValue = 123;

    // slot 3, 4, 5 (one for each array element)
    bytes32[3] public records;

    struct Member {
        uint256 memberId;
        bytes32 memberPassword;
    }

    // slot 6 - array length
    // Array elements stored starting from keccak256(slot)
    Member[] private members;

    // slot 7 - empty
    // Mapping entries stored at keccak256(key, slot)
    mapping(uint256 => Member) private idToMember;

    // Constructor to initialize the contract with a secret key
    constructor(bytes32 _secretKey) {
        secretKey = _secretKey;
    }

    // Function to add a new member with a given password
    function registerMember(bytes32 _memberPassword) public {
        Member memory newMember = Member({memberId: members.length, memberPassword: _memberPassword});

        members.push(newMember);
        idToMember[newMember.memberId] = newMember;
    }

    // Function to calculate the storage location of an array element
    function calculateArrayLocation(uint256 slot, uint256 index, uint256 elementSize)
        public
        pure
        returns (uint256)
    {
        return
            uint256(keccak256(abi.encodePacked(slot))) + (index * elementSize);
    }

    // Function to calculate the storage location of a mapping entry
    function calculateMappingLocation(uint256 slot, uint256 key)
        public
        pure
        returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(key, slot)));
    }
}

/*
Storage Layout and Retrieval:
- slot 0: itemCount
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", 0, console.log)

- slot 1: shortNumber, statusFlag, contractOwner
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", 1, console.log)

- slot 2: secretKey
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", 2, console.log)

- slot 6: array length
calculateArrayLocation(6, 0, 2)
web3.utils.numberToHex("111414077815863400510004064629973595961579173665589224203503662149373724986687")
We can also use web3 to get the data location:
web3.utils.soliditySha3({ type: "uint", value: 6 })

First member:
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f", console.log)
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d40", console.log)

Note: use web3.toAscii to convert bytes32 to readable text

Second member:
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d41", console.log)
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", "0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d42", console.log)

- slot 7: empty
calculateMappingLocation(7, 1)
web3.utils.numberToHex("81222191986226809103279119994707868322855741819905904417953092666699096963112")
We can also use web3 to get the data location:
web3.utils.soliditySha3({ type: "uint", value: 1 }, { type: "uint", value: 7 })

Member 1:
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", "0xb39221ace053465ec3453ce2b36430bd138b997ecea25c1043da0c366812b828", console.log)
web3.eth.getStorageAt("0x534E4Ce0ffF779513793cfd70308AF195827BD31", "0xb39221ace053465ec3453ce2b36430bd138b997ecea25c1043da0c366812b829", console.log)
*/
