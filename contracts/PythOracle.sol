// SPDX-License-Identifier: MIT
import "./libraries/external/QueryAccount.sol";
import "./libraries/external/BytesLib.sol";

contract PythOracle {
    using BytesLib for bytes;

    // Solana address of the Pyth price account
    bytes32 priceAccount;
    // Description / Name of the price feed, e.g., "BTC/USD"
    string feedName;
    // Exponent of the price and confidence values (10^exponent)
    int32 public exponent;

    enum PriceStatus {
        // The price feed is not currently updating for an unknown reason. If the PriceInfo has this
        // status, its price represents the last known good price (which may be from an arbitrarily earlier time).
        Unknown,
        // The price feed is currently updating. This status is the typical state of the price feed.
        Trading,
        // The price feed is not currently updating because trading has been halted on external venues.
        // (Non-crypto markets only)
        Halted,
        // The price feed is not currently updating because external venues are using an auction to set the price.
        // (Non-crypto markets only)
        Auction
    }

    enum CorporateAction {
        NoCorporateAction
    }

    struct PriceInfo {
        // Current price. The price is represented as a fixed-point number, `price * 10^exponent`.
        int64 price;
        // Current confidence interval. The confidence is represented as a fixed point number `confidence * 10^exponent`
        // The confidence interval represents the uncertainty in the price.
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

    /////////////////////////////////////////////////////////////////////////////////////
    // Pyth Native Interface
    // This interface is more powerful than the adapter interface below,
    // as it provides access to the Pyth-specific features such as the confidence interval.
    /////////////////////////////////////////////////////////////////////////////////////

    // Get the current price, confidence and metadata from the oracle.
    // Please see https://docs.pyth.network/consumers/best-practices for best practices on consuming the data
    // returned by this method.
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

    // Get the time-weighted average price (twap) and confidence (twac). Both of these values are
    // the significands of fixed-point numbers, `twap * 10 ^ exponent`. Also returns the last slot
    // when an update occurred.
    function getTimeWeightedInfo() public view returns (int64 twap, uint64 twac, uint64 last_slot) {
        bytes memory accData = QueryAccount.data(priceAccount, 32, 64);
        last_slot = readLittleEndianUnsigned64(accData.toUint64(0));
        twap = readLittleEndianSigned64(accData.toUint64(16));
        twac = readLittleEndianUnsigned64(accData.toUint64(24));
    }

    // Get the price/confidence from the second-most-recent price update. This method returns
    // a valid price from a time before the current price (as returned by getPriceInfo()).
    // price and confidence are the significands of fixed-point numbers of the form `price * 10^exponent`.
    function getPreviousUpdate() public view returns (int64 price, uint64 confidence, uint64 slot) {
        bytes memory accData = QueryAccount.data(priceAccount, 176, 24);
        slot = readLittleEndianUnsigned64(accData.toUint64(0));
        price = readLittleEndianSigned64(accData.toUint64(8));
        confidence = readLittleEndianUnsigned64(accData.toUint64(16));
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Chainlink adapter interface
    // This interface replicates the chainlink Data Feeds API, excluding the historical API.
    /////////////////////////////////////////////////////////////////////////////////////

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