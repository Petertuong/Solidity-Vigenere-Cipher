// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract Vigenere {
    // E = (P + K) % 26
    function vigenereOperation(
        string memory message,
        string memory key,
        bool mode
    ) public pure returns (string memory) {
        bytes memory text = bytes(message);
        bytes memory bytesKey = bytes(key);
        uint8 idxOfKey = 0;

        if (mode == true) {
            //encrypt
            bytes memory encryptedText = new bytes(text.length);

            //casting to bytes is not expensive in solidity, as it only change the label
            for (uint8 i = 0; i < text.length; i++) {
                //cast to bytes array since string doesn't have length
                if (text[i] != 0x20) {
                    //0x20 is the byte representation of <space>
                    uint8 messageIdx = stringLookup(text[i]);
                    uint8 keyIdx = stringLookup(bytesKey[idxOfKey]); //find the shift position from the correspondent key
                    bytes1 e = indexLookup((messageIdx + keyIdx) % 26);
                    encryptedText[i] = e;
                    idxOfKey = (idxOfKey + 1) % uint8(bytesKey.length); //make sure we will reuse the key
                } else {
                    encryptedText[i] = 0x20;
                }
            }

            return string(diffuse(encryptedText));
        }

        if (mode == false) {
            //decrypt
            bytes memory decryptedText = new bytes(text.length);

            for (uint8 i = 0; i < text.length; i++) {
                if (text[i] != 0x20) {
                    uint8 messageIdx = stringLookup(text[i]);
                    uint8 keyIdx = stringLookup(bytesKey[idxOfKey]);
                    bytes1 d = indexLookup((messageIdx + 26 - keyIdx) % 26);
                    decryptedText[i] = d;
                    idxOfKey = (idxOfKey + 1) % uint8(bytesKey.length);
                } else {
                    decryptedText[i] = 0x20;
                }
            }

            return string(decryptedText);
        }
    }

    function diffuse(bytes memory text) public pure returns (bytes memory) {
        uint8 remainedLetter = uint8(text.length % 4); //To find block with not enough 4 letters
        //I do not think it is worth it in solidity to do SPACE stripe
        //And normally, text are not separated with space. But if it does, I think it is more efficient
        //to use python library and hardcode it
        //apologize for my laziness
        for (uint i = 0; i < text.length - remainedLetter; i += 4) {
            bytes1 temp = text[i];
            text[i] = text[i + 2]; // (x,y,z,k) -> (z,y,z,k);
            text[i + 2] = text[i + 3]; // (z,y,z,k) -> (z,y,k,k);
            text[i + 3] = text[i + 1]; // (z,y,k,k) -> (z,y,k,y);
            text[i + 1] = temp; //(z,y,k,y) -> (z,a,k,y);
        }

        return text;
    }

    function stringLookup(bytes1 charBytes) public pure returns (uint8 i) {
        bytes memory alphabet = bytes("abcdefghijklmnopqrstuvwxyz");

        //we can compare bytes, but be careful with different data type of bytes, bytes1, bytes32, etc.
        for (i = 0; i < alphabet.length; i++) {
            if (charBytes[0] == alphabet[i]) {
                return i;
            }
        }
    }

    function indexLookup(uint8 i) public pure returns (bytes1) {
        bytes memory alphabet = bytes("abcdefghijklmnopqrstuvwxyz");

        return alphabet[i];
    }
}
