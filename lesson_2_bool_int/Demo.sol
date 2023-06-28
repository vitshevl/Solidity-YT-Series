// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {

    uint8 public myVal = 254;

    function inc() public {
        // myVal = myVal +1;
        // myVal += 1;
        //myVal++;  //myVal--
        unchecked {
            myVal++;
        }
    }




    // uint public minimum;

    // function demo() public {
    //     minimum = type(uint8).min;
    // }



    // unsigned integers
    // uint public myUint = 42;
    // 2 ** 256
    // uint8 public mySmallUint = 2;
    // 2 ** 8 = 256
    // 0 --> (256-1)
    // uint16
    // uint24
    // uint32
    // ..uint256

    // function demo (uint _inputUint) public {
    //     uint localUint = 42;
    //     localUint + 1;
    //     localUint - 1;
    //     localUint * 2;
    //     localUint / 2;
    //     localUint ** 3;
    //     localUint % 3;
    //     -myInt;

    //     localUint == 1;
    //     localUint != 1;
    //     localUint > 1;
    //     localUint >= 1;
    //     localUint < 2;
    //     localUint <= 2;

    // }

    //signed integers
    // int public myInt = -42;
    // int8 public mySmallInt = -1;
    // 2 ** 7 = 128
    // -128 --> (128-1)


    // bool public myBool;  // state

    // function myFunc (bool _inputBool) public {
    //     bool localBool = false; // local
    //     localBool && _inputBool
    //     localBool || _inputBool
    //     localBool == _inputBool
    //     localBool != _inputBool
    //     !localBool
    //     if (_inputBool || localBool) {

    //     }
    // }

}