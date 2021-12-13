// SPDX-License-Identifier: MIT
import "./libraries/external/QueryAccount.sol";
import "./libraries/external/BytesLib.sol";

contract PythOracle {
    using BytesLib for bytes;

    // Solana address of the Pyth price account
    bytes32 priceAccount;
    // Description / Name of the price feed
    string feedName;
    // Exponent of the price and confidence values (10^exponent)
    int32 public exponent;

    enum PriceStatus {
        Unknown,
        Trading,
        Halted,
        Auction
    }

    enum CorporateAction {
        NoCorporateAction
    }

    struct PriceInfo {
        // Current price
        int64 price;
        // Current confidence interval
        uint64 confidence;
        // Status of the price-feed
        PriceStatus status;
        // Corporate action
        CorporateAction corporateAction;
        // Solana slot the price was last updated
        uint64 updateSlot;
    }

    constructor (bytes32 _priceAccount, string memory _feedName){
        priceAccount = _priceAccount;
        feedName = _feedName;

        // Fetch exponent and store it
        bytes memory accData = QueryAccount.data(priceAccount, 20, 4);
        exponent = readLittleEndianSigned32(accData.toUint32(0));
    }

    // Get the current aggregate price info of the feed
    function getPriceInfo() public view returns (PriceInfo memory){
        PriceInfo memory info;

        // Read price account
        bytes memory accData = QueryAccount.data(priceAccount, 208, 32);

        info.price = readLittleEndianSigned64(accData.toUint64(0));
        info.confidence = readLittleEndianUnsigned64(accData.toUint64(8));
        info.status = PriceStatus(readLittleEndianUnsigned32(accData.toUint32(16)));
        info.corporateAction = CorporateAction(readLittleEndianUnsigned32(accData.toUint32(20)));
        info.updateSlot = readLittleEndianUnsigned64(accData.toUint64(24));

        return info;
    }

    // Get the twap, twac and last slot an update was made
    function getTimeWeightedInfo() public view returns (int64 twap, uint64 twac, uint64 last_slot) {
        bytes memory accData = QueryAccount.data(priceAccount, 32, 48);
        last_slot = readLittleEndianUnsigned64(accData.toUint64(0));
        twap = readLittleEndianSigned64(accData.toUint64(16));
        twac = readLittleEndianUnsigned64(accData.toUint64(40));
    }

    // Get the last successful price update
    function getPreviousUpdate() public view returns (int64 price, uint64 confidence, uint64 slot) {
        bytes memory accData = QueryAccount.data(priceAccount, 176, 24);
        slot = readLittleEndianUnsigned64(accData.toUint64(0));
        price = readLittleEndianSigned64(accData.toUint64(8));
        confidence = readLittleEndianUnsigned64(accData.toUint64(16));
    }

    // Adapter functions for Chainlink's aggregator interface
    // We don't support the historical api
    function latestAnswer() external view returns (int256){
        PriceInfo memory priceInfo = getPriceInfo();
        return int256(priceInfo.price);
    }

    function latestRound() external view returns (uint256){
        PriceInfo memory priceInfo = getPriceInfo();
        return uint256(priceInfo.updateSlot);
    }

    function latestTimestamp() external view returns (uint256){
        // TODO this is not correct
        return block.timestamp;
    }

    function latestRoundData()
    external
    view
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ){
        PriceInfo memory priceInfo = getPriceInfo();

        return (
        uint80(priceInfo.updateSlot),
        int256(priceInfo.price),
        uint256(block.timestamp),
        uint256(block.timestamp),
        // TODO not correct
        uint80(block.timestamp)
        );
    }

    function decimals() external view returns (uint8){
        require(exponent <= 0 && exponent > - 255, "invalid exponent for interface compatibility");
        return uint8(uint32(- exponent));
    }

    function description() external view returns (string memory){
        return feedName;
    }

    function version() external view returns (uint256){
        return 4;
    }

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
