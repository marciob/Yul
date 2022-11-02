// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//Yul only has 32bytes as a type, so it doesn't have booleans
//the way
contract ifComparison {
    function isTruthy() external pure returns (uint256 result) {
        result = 2;

        assembly {
            //if 2 is true, return 1
            //in assembly doesn't exist else, just if
            if 2 {
                result := 1
            }
        }

        return result; //if 2 is false, return 2
    }

    function isFalsy() external pure returns (uint256 result) {
        result = 1;

        assembly {
            if 0 {
                result := 2
            }
        }

        return result;
    }

    function negation() external pure returns (uint256 result) {
        result = 1;

        assembly {
            if iszero(0) {
                result := 2
            }
        }

        return result;
    }

    function bitFlip() external pure returns (uint256 result) {
        assembly {
            result := not(2)
        }
    }

    function unsafeNegationPart() external pure returns (uint256 result) {
        result = 1;

        assembly {
            if not(2) {
                result := 2
            }
        }

        return result;
    }

    function max(uint256 x, uint256 y) external pure returns (uint256 maximum) {
        assembly {
            if lt(x, y) {
                maximum := y
            }

            if iszero(lt(x, y)) {
                maximum := x
            }
        }
    }
}

//  solidity    Yul
//  a && b      and(a,b)
//  a || b      or(a,b)
//  a ^ b       xor(a,b)
//  a + b       add(a,b)
//  a - b       sub(a,b)
//  a * b       mul(a,b)
//  a / b       div(a,b)
//  a % b       mod(a,b)
