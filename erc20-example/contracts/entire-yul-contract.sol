// SPDX-License-Identifier: GPL-3.0

/** 
    To Learn

    1. constructor
    2. yul doesn't have to respect call data
    3. how to compile yul
    4. how to interact with yul
    5. custom code in the constructor

**/

//this contract is not compiled with default solidity compiler
//it's compiled with a yul compile configuration
//one way to better interact with on remix is deploying and call it as interface inside a normal contract
object "Simple" {
    // it's the constructor
    code {
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))        
    }

    object "runtime" {
        
        code {
            mstore(0x00, 2)
            return(0x00, 0x20)
        }
    }
}
