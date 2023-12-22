// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract AuctionContract {
    IERC721 public token;

    address public auctioneer;
    uint256 public tokenId;
    uint256 public reservePrice;
    uint256 public auctionEndTime;

    address public highestBidder;
    uint256 public highestBid;

    // Allowed withdrawals of previous bids
    // The pending returns are funds that were previously used to place a bid but were later overbid by another participant. 
    mapping(address => uint256) pendingReturns;

    bool public ended;

    event AuctionEnded(address winner, uint256 winningBid);

    constructor(
        address _tokenAddress,
        uint256 _tokenId,
        uint256 _reservePrice,
        uint256 _duration
    ) {
        token = IERC721(_tokenAddress);
        auctioneer = msg.sender;
        tokenId = _tokenId;
        reservePrice = _reservePrice;
        auctionEndTime = block.timestamp + _duration;
    }

    modifier onlyBeforeEnd() {
        require(!ended, "Auction already ended");
        _;
    }

    modifier onlyAfterEnd() {
        require(ended, "Auction not yet ended");
        _;
    }

    modifier onlyAuctioneer() {
        require(msg.sender == auctioneer, "Not the auctioneer");
        _;
    }

    function bid() external payable onlyBeforeEnd {
        require(msg.value > reservePrice, "Bid amount too low");
        require(msg.value > highestBid, "Bid amount too low");

        if (highestBid > 0) {
            // Refund the previous highest bidder
            pendingReturns[highestBidder] =  pendingReturns[highestBidder] + highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    // Withdraw a bid that was overbid.
    function withdraw() external {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingReturns[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdrawal failed");
    }

    function endAuction() external onlyAfterEnd onlyAuctioneer {
        require(!ended, "Auction already ended");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // Transfer the NFT to the highest bidder
        token.safeTransferFrom(address(this), highestBidder, tokenId);

        // Transfer the funds to the auctioneer
        (bool success, ) = payable(auctioneer).call{value: highestBid}("");
        require(success, "Transfer failed");
    }

    function extendAuction(uint256 _duration) external onlyAuctioneer {
        require(!ended, "Auction already ended");
        auctionEndTime += _duration;
    }

    function timeRemaining() external view returns (uint256) {
        if (block.timestamp >= auctionEndTime) {
            return 0;
        } else {
            return auctionEndTime - block.timestamp;
        }
    }
}
