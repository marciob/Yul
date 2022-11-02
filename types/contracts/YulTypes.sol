// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//technically Yul isn't an assembly language, it's one level of abstraction above assembly
//real assembly doesn't have the concept of variables, functions, for-loops, if statements, which Yul has

contract YulTypes {
    function getNumber() external pure returns (uint256) {
        uint256 x;

        //all Yul code goes inside an assembly block
        //Yul only have 1 type: uint256
        //Yul declaration comes with :=
        //Yul doesn't use ; at the end of declarations
        assembly {
            x := 42
        }

        // it will return 42
        return x;
    }

    function getHex() external pure returns (uint256) {
        uint256 x;

        //
        assembly {
            x := 0xa
        }

        // it will return 10, which is the uint256 version of 0xa
        return x;
    }

    function demoString() external pure returns (bytes32) {
        bytes32 myString = "";

        assembly {
            myString := "hello world"
        }

        // it will return the representation of "hello world"
        return myString;

        //it will return "hello world"
        //return string(abi.encode(myString));
    }

    function representation() external pure returns (bool) {
        bool x;

        assembly {
            x := 1
        }

        //it will return true, because in solidity a true is a 32bytes with 1 at the end
        //if the return function was "uint16", the return would be 1
        //if the return function was "address", the return would be like 0x00000000000000000000000001
        return x;
    }
}
