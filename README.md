# Vignere Cipher

## Overview

Vignere Cipher is basically caesar cipher using word like key instead of identical key for every character. Each character in the plain text will be shifted based on the position of the corresspondent letter of the key:

### Encryption Formula

```text
Encryption = (PlainTextLetterPosition + KeyLetterPosition) % 26
```

### Decryption Formula

```text
Decryption = (CipherTextLetterPosition + 26 - KeyLetterPosition) % 26
```

> note: the + 26 is to prevent overflow

Although vignere cipher is very easy to perform, with solidity, I find it is a little bit more challenging due to the syntax and constraint of the language itself.

---

## Challenges in Solidity

The biggest conundrum in this challenge (before working with diffusion), is dealing with bytes data type. This is due to the nature of solidity data type:

1. String manipulation in solidity is significantly difficult and gas expensive. Using `string.concat` will create a new copy of the string, which is very inefficient. Aside from that, to access each character of the string, we have to cast it into `bytes`.

2. `bytes1`, `bytes32`, etc. are fixed bytes array. Thus it is not usable to cast to string. This is because string itself is a reference, and dynamically sized array, thus we have to cast it to type `bytes32` and vice versa.

3. you cannot cast a dynamically size array of type `bytes` to fix sized array of bytes and vice versa.

4. you cannot compare string. You cannot compare fixed-size bytes array with dynamicall size bytes.

5. `assertEq` doesn't work with type `bytes1`

---

## Conclusion

After achieving the task, I think (hopefully) I have better understanding of solidity fundamentals. Now I will move on to creating diffusion in the message.