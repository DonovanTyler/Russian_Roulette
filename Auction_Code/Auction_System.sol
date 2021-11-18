pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract AuctionSystem {
    string itemName;
	uint256 currentPrice;
	uint256 finalPrice;
	string description;
	uint256 minimumPrice;
	uint256 bidTime;
	uint256 minimumIncrement;
	string currency;
	IERC721 nsfw;
	address highestBidder;
    uint256 timeLeft;
    uint256 bidCount;
    uint256 timeExtensions = 0;
    uint256 originalTime;
    function openAuction (uint256 minPrice, uint256 time, IERC721 nft, string memory descrip, uint256 increment) public {
        minimumPrice = minPrice;
        originalTime = block.timestamp;
	    bidTime = block.timestamp + time;
        nsfw = nft;
        description = descrip;
	    minimumIncrement = increment;
    }
    
    modifier isEnded{
        require(block.timestamp>bidTime);
        _;
    }
    
    function bid() external payable{
    if(msg.value > (currentPrice + minimumIncrement)) {
		currentPrice = msg.value;
		highestBidder = msg.sender;
		if(bidTime >= 10 seconds && timeExtensions < 10 seconds) {
			bidTime += 10 seconds;
			timeExtensions++;
        }
    }
}
function win(uint256 nftId) external payable isEnded {
        require(msg.sender == highestBidder);
        nsfw.safeTransferFrom(address (this), msg.sender, nftId);
        //seller.transfer(msg.value);
    }
}