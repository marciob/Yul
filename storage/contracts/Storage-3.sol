// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//each slot can store up to 256bits = 32 bytes
//default value of each slot is 0
//variables are stored from right to left
//dynamic size arrays and mappings create a new slot that stores the length of the array
//      the values of the array are stored at other locations
//strings create a new slot to store data and length
//all variables are stored in the contract and accesible, regardless it is internal, public, private or not

contract StorageComplex {
    uint256[3] fixedArray;
    // it's like:
    // uint256 a;
    // uint256 b;
    // uint256 c;
    uint256[] bigArray;
    uint8[] smallArray;

    mapping(uint256 => uint256) public myMapping;
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;
    mapping(address => uint256[]) public addressToList;

    constructor() {
        fixedArray = [99, 999, 9999];
        bigArray = [10, 20, 30, 40];
        smallArray = [1, 2, 3];

        myMapping[10] = 5;
        myMapping[11] = 6;
        nestedMapping[2][4] = 7;

        addressToList[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = [
            42,
            1337,
            777
        ];
    }

    function fixedArrayView(uint256 index) external view returns (uint256 ret) {
        assembly {
            // it returns the data stored in a fixed array at the slot location passed by the user using an index
            // to do that, it sums up the location slot with the index desired by the user
            // per example, if the user wants to get the first slot, he should pass 0 as index
            ret := sload(add(fixedArray.slot, index))
        }
    }

    function bigArrayLength() external view returns (uint256 ret) {
        assembly {
            // in short, it returns the length of a dynamic array
            // it returns what is stored in the bigArray slot location
            // in this case, considering that's a dynamic array, it stores a length
            ret := sload(bigArray.slot)
        }
    }

    function readBigArrayLocation(uint256 index)
        external
        view
        returns (uint256 ret)
    {
        uint256 slot;
        assembly {
            // it returns the location slot of bigArray (dynamic array)
            slot := bigArray.slot
        }

        // it hashes the bigArray location
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            // it sums the location with the index passed by the user and return what is stored there
            // so if it pass 0 as index, it will return what is stored at the first slot location of that dynamic array
            ret := sload(add(location, index))
        }
    }

    function readSmallArray() external view returns (uint256 ret) {
        assembly {
            ret := sload(smallArray.slot)
        }
    }

    // it reads what is stored at the slot location passed in the index
    // in this example since that smallArray is a uint8, when looking for the first index, it will return:
    // 0x0000000000000000000000000000000000000000000000000000000000030201
    // in that case, considering that each pair of those decimals is 1 bit, all the 3 items of the array are stored at the end: 030201
    function readSmallArrayLocation(uint256 index)
        external
        view
        returns (bytes32 ret)
    {
        uint256 slot;
        assembly {
            slot := smallArray.slot
        }
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            ret := sload(add(location, index))
        }
    }

    // it returns what is stored in a mapping
    function getMapping(uint256 key) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := myMapping.slot
        }
        // when concatenating, it adds a key, which represents the mapping item
        // doing that it places the exact location of that item, so it just need to get the data directly when usin sload()
        bytes32 location = keccak256(abi.encode(key, uint256(slot)));

        assembly {
            ret := sload(location)
        }
    }

    // it returns what is stored in a nested mapping
    function getNestedMapping() external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := nestedMapping.slot
        }

        // it's similar process as a common mapping, but in this case it's a hash of hash
        // in this example the keys are hard coded (2 and 4), once the mapping is nestedMapping[2][4] = 7;
        bytes32 location = keccak256(
            abi.encode(
                uint256(4),
                keccak256(abi.encode(uint256(2), uint256(slot)))
            )
        );
        assembly {
            ret := sload(location)
        }
    }

    // this is a helper function to know the length of a nested mapping which is linked to a dynamic array
    // that information is necessary because that mapping has a dynamic array
    function lengthOfNestedList() external view returns (uint256 ret) {
        uint256 addressToListSlot;
        assembly {
            addressToListSlot := addressToList.slot
        }

        bytes32 location = keccak256(
            abi.encode(
                address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4),
                uint256(addressToListSlot)
            )
        );
        assembly {
            ret := sload(location)
        }
    }

    function getAddressToList(uint256 index)
        external
        view
        returns (uint256 ret)
    {
        uint256 slot;
        assembly {
            slot := addressToList.slot
        }

        // the key is hard coded (0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
        bytes32 location = keccak256(
            abi.encode(
                keccak256(
                    abi.encode(
                        address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4),
                        uint256(slot)
                    )
                )
            )
        );
        assembly {
            ret := sload(add(location, index))
        }
    }
}
