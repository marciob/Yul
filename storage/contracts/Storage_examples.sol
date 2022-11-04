// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//example from https://kubertu.com/blog/solidity-storage-in-depth/

contract StorageTest {
    uint256 a; //it occupies storage location 0
    uint256[2] b; //because each data is 256bits, it occupies storage location 1 and 2:
    //              location 1: b[0]
    //              location 2: b[1]
    struct Entry {
        //it was just declared, nothing was stored, so it doesn't count
        uint256 id;
        uint256 value;
    }
    Entry c; //because each data inside the struct is 256bits, it occupies storage location 3 and 4:
    //              location 3: c.id
    //              location 4: c.value
}
