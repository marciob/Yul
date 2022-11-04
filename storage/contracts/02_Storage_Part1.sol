// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//each slot can store up to 256bits = 32 bytes
//default value of each slot is 0
//variables are stored from right to left
//dynamic size arrays and mappings create a new slot that stores the length of the array
//      the values of the array are stored at other locations
//strings create a new slot to store data and length
//all variables are stored in the contract and accesible, regardless it is internal, public, private or not

contract StoragePart1 {
    uint128 public C = 4;
    uint96 public D = 6;
    uint16 public E = 8;
    uint8 public F = 1;

    function readBySlot(uint256 slot) external view returns (bytes32 value) {
        assembly {
            value := sload(slot)
        }
    }

    function getOffsetE() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := E.slot //it returns the slot of E
            offset := E.offset //it returns the exact point of the slot to look to find E variable,
            //                  in this example, it returns 8, why:
            //                  E is storing uint16 8, which is located at the slot 0,
            //                  but it's being stored together with other data, slot 0 stores:
            //                  0x0001000800000000000000000000000600000000000000000000000000000004
            //                  in this case, 8 is placed at the 28 bits from right to the left (each pair of those decimals is 1 bit)
        }
    }

    //this function was created to confirm the value of E
    //it is being made by shifting it to a separated slot
    function readE() external view returns (uint16 e) {
        assembly {
            let value := sload(E.slot) // must load in 32 byte increments
            // at this point value is being equal to 0x0001000800000000000000000000000600000000000000000000000000000004
            let shifted := shr(mul(E.offset, 8), value) //here it shift to right by 28 bits
            // when shifting, it will return:
            //  0x0000000000000000000000000000000000000000000000000000000000010008
            //which is equivalent to:
            //  0x000000000000000000000000000000000000000000000000000000000000ffff

            e := and(0xffff, shifted)
        }
    }
}
