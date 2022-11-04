// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//example from https://kubertu.com/blog/solidity-storage-in-depth/

contract StorageTest {
    uint256 a; // storage location (slot): 0
    uint256[3] b; // storage location (slot): 1-2-3
    struct Entry {
        uint256 id;
        uint256 value;
    }
    Entry c; // slots 4-5
    uint256[] d;
    Entry[] e;

    constructor() {
        d.push(1);
        d.push(2);
        d.push(3);
        e.push(Entry(4, 5));
    }
}
