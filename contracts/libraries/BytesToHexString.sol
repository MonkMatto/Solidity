// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.7;

/**
 * The following library is licensed CC BY-SA 4.0.
 * @title BytesToHexString Library
 * @notice Provides a function for converting bytes into a hexidecimal string.
 * @author Mikhail Vladimirov (with edits by Matto)
 * @dev Code in this library is based on the thorough example and walkthrough
 * posted by Mikhail Vladimirov on https://stackoverflow.com/ using the 
 * CC BY-SA 4.0 license.
 */
library BytesToHexString {

  /**
   * @notice toHex takes bytes data and returns the data as a string.
   * @dev This is needed to convert the token entropy (bytes) into a string for
   * return in the scriptInputsOf function. This is the function that is called
   * first, and it calls toHex16 while processing the return.
   * @param _data is the bytes data to convert.
   * @return (string)
   */
  function toHex(bytes32 _data)
    internal
    pure
    returns (string memory) 
  {
    return string(
        abi.encodePacked(
            "0x",
            toHex16(bytes16(_data)),
            toHex16(bytes16(_data << 128))
        )
    );
  }

  /**
   * @notice toHex16 is a helper function of toHex.
   * @dev For an explanation of the operations, see Mikhail Vladimirov's 
   * walkthrough for converting bytes to string on https://stackoverflow.com/.
   * @param _input is a bytes16 data chunk.
   * @return output is a bytes32 data chunk.
   */
  function toHex16(bytes16 _input)
    internal
    pure
    returns (bytes32 output) 
  {
    output = bytes32(_input) & 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000 |
      (bytes32(_input) & 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >> 64;
    output = output & 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000 |
      (output & 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >> 32;
    output = output & 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000 |
      (output & 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >> 16;
    output = output & 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000 |
      (output & 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >> 8;
    output = (output & 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >> 4 |
      (output & 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >> 8;
    output = bytes32 (0x3030303030303030303030303030303030303030303030303030303030303030 +
      uint256(output) +
      (uint256(output) + 0x0606060606060606060606060606060606060606060606060606060606060606 >> 4 &
      0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) * 7);
  }
}