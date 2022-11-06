// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// functions to handle memory:
// mload(x) -> retrieves 32bytes from slot p
// mstore(x, y) -> stores value y in the slot x (just like sload())
// mstore8() -> it's like mstore, but used only for 1 byte
// msize() -> retrieves largest accessed memory index in that transaction

// in Yul pure code, memory is used very easy, but in mixed Solidity and Yul code, memory have specific details

// one of the advantages of using memory is because gas are charged not only for memory access, but also for how far the memory array is accessed

contract Memory {
    struct Point {
        uint256 x;
        uint256 y;
    }

    event MemoryPointer(bytes32);
    event MemoryPointerMsize(bytes32, bytes32);

    function highAccess() external pure {
        assembly {
            // pop just throws away the return value
            pop(mload(0xffffffffffffffff))
        }
    }

    function mstore8() external pure {
        assembly {
            mstore8(0x00, 7)
            mstore(0x00, 7)
        }
    }

    function memPointer() external {
        bytes32 x40;
        assembly {
            // it's where free memory pointer is stored
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40); // it's emmited to facilitate the reading of the data at that point
        //                      at this point it emmits:
        // 0x0000000000000000000000000000000000000000000000000000000000000080
        Point memory p = Point({x: 1, y: 2});

        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40); // it's emmited to facilitate the reading of the data at that point
        //                      at this point it emmits:
        // 0x00000000000000000000000000000000000000000000000000000000000000c0
        // 0xc0 - 0x80 = 64, in this case 64 is 2x 32 bytes
        // it happens because it's referring to x and y, at this point they occupied memory location when being declared in this function
    }

    function memPointerV2() external {
        bytes32 x40;
        bytes32 _msize;
        assembly {
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);

        Point memory p = Point({x: 1, y: 2});
        assembly {
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);

        assembly {
            pop(mload(0xff))
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);
    }

    function fixedArray() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        uint256[2] memory arr = [uint256(5), uint256(6)];
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncode() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        abi.encode(uint256(5), uint256(19));
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncode2() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        abi.encode(uint256(5), uint128(19));
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncodePacked() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        abi.encodePacked(uint256(5), uint128(19));
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    event Debug(bytes32, bytes32, bytes32, bytes32);

    function args(uint256[] memory arr) external {
        bytes32 location;
        bytes32 len;
        bytes32 valueAtIndex0;
        bytes32 valueAtIndex1;
        assembly {
            location := arr
            len := mload(arr)
            valueAtIndex0 := mload(add(arr, 0x20))
            valueAtIndex1 := mload(add(arr, 0x40))
            // ...
        }
        emit Debug(location, len, valueAtIndex0, valueAtIndex1);
    }

    function breakFreeMemoryPointer(uint256[1] memory foo)
        external
        view
        returns (uint256)
    {
        assembly {
            mstore(0x40, 0x80)
        }
        uint256[1] memory bar = [uint256(6)];
        return foo[0];
    }

    uint8[] foo = [1, 2, 3, 4, 5, 6];

    function unpacked() external {
        uint8[] memory bar = foo;
    }
}
