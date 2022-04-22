// SPDX-License-Identifier: MIT
import "./libraries/external/QueryAccount.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";

contract PythOracle {
    using BytesLib for bytes;

    // Little Endian helpers

    function readLittleEndianSigned64(uint64 input) internal pure returns (int64) {
        uint64 val = input;
        val = ((val << 8) & 0xFF00FF00FF00FF00) | ((val >> 8) & 0x00FF00FF00FF00FF);
        val = ((val << 16) & 0xFFFF0000FFFF0000) | ((val >> 16) & 0x0000FFFF0000FFFF);
        return int64((val << 32) | ((val >> 32) & 0xFFFFFFFF));
    }

    function readLittleEndianUnsigned64(uint64 input) internal pure returns (uint64 val) {
        val = input;
        val = ((val << 8) & 0xFF00FF00FF00FF00) | ((val >> 8) & 0x00FF00FF00FF00FF);
        val = ((val << 16) & 0xFFFF0000FFFF0000) | ((val >> 16) & 0x0000FFFF0000FFFF);
        val = (val << 32) | (val >> 32);
    }

    function readLittleEndianSigned32(uint32 input) internal pure returns (int32) {
        uint32 val = input;
        val = ((val & 0xFF00FF00) >> 8) |
        ((val & 0x00FF00FF) << 8);
        return int32((val << 16) | ((val >> 16) & 0xFFFF));
    }

    function readLittleEndianUnsigned32(uint32 input) internal pure returns (uint32 val) {
        val = input;
        val = ((val & 0xFF00FF00) >> 8) |
        ((val & 0x00FF00FF) << 8);
        val = (val << 16) | (val >> 16);
    }
}
