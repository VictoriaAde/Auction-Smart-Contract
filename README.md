# Auction Smart Contract

## Overview

This repository contains a simple Ethereum smart contract for conducting auctions using the ERC721 token standard. The auction contract allows users to bid on a specified ERC721 token, and the ownership of the token is transferred to the highest bidder once the auction ends.

## Smart Contract Details

### AuctionContract.sol

- **`AuctionContract`**: The main smart contract that facilitates the auction process.
  
  - **Constructor Parameters**:
    - `_tokenAddress`: Address of the ERC721 token contract.
    - `_tokenId`: ID of the token to be auctioned.
    - `_reservePrice`: Minimum bid required to participate in the auction.
    - `_duration`: Duration of the auction in seconds.

  - **Functions**:
    - `bid()`: Allows participants to place bids in the auction.
    - `withdraw()`: Allows participants to withdraw a bid that was overbid.
    - `endAuction()`: Ends the auction and transfers the NFT to the highest bidder.
    - `extendAuction(uint256 _duration)`: Extends the auction end time.
    - `timeRemaining()`: Returns the time remaining until the auction ends.

### TokenBid.sol

- **`TokenBid`**: An ERC721 token contract used for testing the auction.

  - **Constructor Parameters**:
    - `name`: Name of the ERC721 token.
    - `symbol`: Symbol of the ERC721 token.
    - `initialOwner`: Address of the initial owner of the token.

  - **Functions**:
    - `mint(address to, uint256 tokenId)`: Allows the owner to mint new tokens.

## Testing the Smart Contract

### Using Remix IDE

1. **Deploy TokenBid Contract**:
    - Deploy the `TokenBid` contract first by providing the name, symbol, and the address of the initial owner.

2. **Deploy AuctionContract**:
    - Deploy the `AuctionContract` contract by providing the address of the deployed `TokenBid` contract, the token ID, reserve price, and duration.

3. **Testing Bidding**:
    - Use the `bid()` function in the `AuctionContract` to place bids. Ensure that the bid amount is higher than the reserve price and the current highest bid.

4. **Withdrawing Bids**:
    - Use the `withdraw()` function to withdraw a bid that was overbid. The withdrawn funds will be refunded.

5. **Ending the Auction**:
    - After the auction duration has passed, use the `endAuction()` function to end the auction. The NFT will be transferred to the highest bidder, and funds will be transferred to the auctioneer.

6. **Extending the Auction**:
    - If needed, use the `extendAuction(uint256 _duration)` function to extend the auction end time.

7. **Checking Time Remaining**:
    - Use the `timeRemaining()` function to check the time remaining until the auction ends.


### Viewing the Contract on Etherscan
You can view the contract on Etherscan by visiting the following [link](https://sepolia.etherscan.io/tx/0x9f78bcdfebaef52d2e10fa7f02a74457d7154bba532ef513fd8b7d3401f8caa3)
