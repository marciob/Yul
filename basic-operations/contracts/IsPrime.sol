// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract IsPrime {
    function isPrime(uint256 x) public pure returns (bool) {
        p = true;

        assembly {
            //yul doesn't have signal operations, it uses functions for that
            //in solidity it would be: uint256 half = x / 2 + 1;
            let halfX := add(div(x, 2), 1)

            for {let i := 2}
        }
    }
}
