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
    //Using 1.5 minutes for this tester for time
    constructor (uint256 minPrice, string memory descrip, uint256 increment) public payable{
        minimumPrice = minPrice;
        originalTime = block.timestamp;
	    bidTime = block.timestamp +  1.5 * 1 minutes;
        nsfw  = IERC721(address (0x13066EE900a8C4e2C9cD7cE0096ADF9B907D0CfF));
        description = descrip;
	    minimumIncrement = increment;
    }
    
    modifier isEnded{
        require(bidTime-block.timestamp <= 0);
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
function transferTest(uint256 nftId) external payable{
    nsfw.safeTransferFrom(address (this), 0x032f3d8806EFFB5cC161A98d881c25763F4590D9, nftId);
}

function win(uint256 nftId) external payable isEnded {
        require(msg.sender == highestBidder);
        nsfw.safeTransferFrom(address (this), msg.sender, nftId);
        //seller.transfer(msg.value);
    }
}