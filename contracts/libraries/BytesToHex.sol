// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.7;

/// [CC BY-SA 4.0]
/// @title BytesToHexString
/// @notice Provides a function for converting bytes into a hexidecimal string.
/// @author Mikhail Vladimirov (minor editing by Matto)
/// Functions 'toHex16' and 'toHex' are thanks to the thorough example and walkthrough
/// by Mikhail Vladimirov on https://stackoverflow.com/ using license CC BY-SA 4.0
library BytesToHex {
  function toHex(bytes32 _data)
    public
    pure
    returns (string memory) 
  {
    return string(abi.encodePacked("0x",toHex16(bytes16(_data)),toHex16(bytes16(_data << 128))));
  }

  function toHex16(bytes16 _data)
    internal
    pure
    returns (bytes32 result) 
  {
    result = bytes32(_data) & 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000 |
      (bytes32(_data) & 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >> 64;
    result = result & 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000 |
      (result & 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >> 32;
    result = result & 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000 |
      (result & 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >> 16;
    result = result & 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000 |
      (result & 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >> 8;
    result = (result & 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >> 4 |
      (result & 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >> 8;
    result = bytes32 (0x3030303030303030303030303030303030303030303030303030303030303030 +
      uint256(result) +
      (uint256(result) + 0x0606060606060606060606060606060606060606060606060606060606060606 >> 4 &
      0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) * 7);
  }
}