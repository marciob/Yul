// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//sload(_slot) it loads the value of the _slot location
//sstore(_slot, _value) it stores the _value inside the _slot location
//_variableName.slot it returns the memory location of the variable

contract StorageBasics {
    uint256 x = 2; //slot location: 0
    uint256 y = 13; //slot location: 1
    uint256 z = 54; //slot location: 2
    uint256 p; //slot location: 3

    function getXYul() external view returns (uint256 ret) {
        //assembly only accepts local variables
        //to use storage variables (x, in this case), it needs to use .slot or .offset
        //.slot get the memory location
        //x.slot is the memory location, in this example it's 0
        //to load the value in that memory location, use sload(x.slot)
        assembly {
            ret := sload(x.slot)
        }
    }

    function getVarYul(uint256 slot) external view returns (uint256 ret) {
        assembly {
            ret := sload(slot)
        }
    }

    function setVarYul(uint256 slot, uint256 value) external {
        assembly {
            sstore(slot, value)
        }
    }

    function setX(uint256 newVal) external {
        x = newVal;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function getP() external view returns (uint256) {
        return p;
    }
}
