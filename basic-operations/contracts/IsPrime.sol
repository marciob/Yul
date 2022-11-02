// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract IsPrime {
    function isPrime(uint256 x) public pure returns (bool p) {
        p = true;

        assembly {
            //yul doesn't have signal operations, it uses functions for that
            //in solidity it would be: uint256 half = x / 2 + 1;
            let halfX := add(div(x, 2), 1)

            // it test every number from i to its half, and add 1 more each time
            for {
                let i := 2
            } lt(i, halfX) {
                i := add(i, 1)
            } {
                //if the mod is not zero, we know it isn't prime
                if iszero(mod(x, i)) {
                    p := 0
                    break
                }

                i := add(i, 1)
            }
        }
    }

    function testPrime() external pure {
        require(isPrime(2));
        require(isPrime(3));
        require(!isPrime(4));
        require(!isPrime(15));
        require(isPrime(23));
        require(isPrime(101));
    }
}
