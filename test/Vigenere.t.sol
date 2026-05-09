// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Vigenere} from "../src/Vigenere.sol";
import {console} from "forge-std/console.sol";

contract VigenereTest is Test {
    Vigenere public vigenere;
    string public cipherText;
    string public key;
    string public message;

    function setUp() public {
        vigenere = new Vigenere();
        cipherText = "altdw lhsw gl tg kmurox kxzasow";
        message = "hello this is my secret message";
        key = "thisisakey";
    }

    function test_encrypt() public {
        assertEq(vigenere.vigenereOperation(message, key, true), cipherText);
    }

    function test_decrypt() public {
        assertEq(vigenere.vigenereOperation(cipherText, key, false), message);
    }

    function test_strLookUp() public view {
        assertEq(vigenere.stringLookup("b"), 1);
    }

    function test_indexLookUp() public view {
        assertEq(uint8(vigenere.indexLookup(1)), uint8(0x62)); //have to cast since assertEq doesn't handle type bytes1
    }
}
