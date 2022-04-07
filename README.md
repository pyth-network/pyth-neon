# Pyth on Neon

This repo contains a smart contract making Pyth price feeds available on Neon EVM.

### How to use

The Pyth wrapper supports both the Chainlink Aggregator Interface as well as the pyth-optimized native interface:

```solidity
function getPriceInfo() public view returns (PriceInfo memory);

// Exponent of the price and confidence values (10^exponent)
int32 public exponent;

// Exponent converted to the number of decimals for easier consumption
function decimals() external view returns (uint8);

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

enum PriceStatus {
    Unknown,
    Trading,
    Halted,
    Auction
}

enum CorporateAction {
    NoCorporateAction
}
```


### How to deploy

1. Create a `.secret` file containing the private key or mnemonic of the account you want to use to deploy the
   contracts.
2. Optional: Edit `truffle-config.js` to add the neon network you want to deploy to.
3. Run `truffle migrate --network neon_devnet`
