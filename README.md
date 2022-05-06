# Pyth on Neon

This repo contains a smart contract making Pyth price feeds available on Neon EVM.

It is **strongly recommended** to follow the [consumer best practices](https://docs.pyth.network/consumers/best-practices) when consuming Pyth data.

### How to use

To consume prices, you need to look up the price feed ID for the symbol you're interested in. The NEON Devnet price feed IDs are listed [here](https://pyth.network/developers/price-feeds/#neon-evm-devnet).

```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";

contract ExampleContract {

    function getBTCUSDPrice() public returns (PythStructs.Price memory) {

        // The NEON Devnet price feed ID of BTC/USD
        bytes32 priceID = 0xf9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b;

        return pyth.getCurrentPrice(priceID);
    }
    
}
```


### How to deploy

1. Create a `.secret` file containing the private key or mnemonic of the account you want to use to deploy the
   contracts.
2. Optional: Edit `truffle-config.js` to add the neon network you want to deploy to.
3. Run `truffle migrate --network neon_devnet`
