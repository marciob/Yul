// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//example from https://kubertu.com/blog/solidity-storage-in-depth/

contract StorageTest {
    uint8 public a = 7; //storage location: 0
    uint16 public b = 10; //storage location: 0
    address public d = 0xbE03bCA4D65A86114668697867982Ecfc76f15F8; //storage location: 0, address has 40 hexadecimal characters, so 160 bits
    bool public bb = true; //storage location: 0
    //                     bool type only need 1 bit to store, but in solidity, the smallest data type is 8 bits,
    //                     so bool type occupies 8 bits;
    uint64 public c = 15; //storage location: 0
    uint256 public e = 200; //storage location: 1
    uint8 public f = 40; //storage location: 2
    uint256 public g = 789; //storage location: 3
}
