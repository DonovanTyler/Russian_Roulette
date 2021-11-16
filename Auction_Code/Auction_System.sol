pragma solidity >=0.7.0 <0.9.0;

interface IERC721 {
    function transfer(address, uint) external;

    function safeTransferFrom(
        address,
        address,
        uint
    ) external;
}
contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;
    uint256 timeExtensions;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start(uint256 minutesLeft) external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        nft.safeTransferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + minutesLeft;

        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
        
        if(endAt > 10 seconds && timeExtensions < 10) {
            endAt += 10 seconds;
            timeExtensions++;
        }
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.transfer(highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transfer(seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}

contract WinAuction {
    
    event Win(address winner, uint256 amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    address public winner;

    constructor(
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        nft = IERC721(_nft);
        nftId = _nftId;
    }
    modifier onlyWinner {
        require(msg.sender == winner);
        _;
    }
    // Winds the auction for the specified amount
    function win() external payable onlyWinner{
        nft.safeTransferFrom(seller, msg.sender, nftId);
        seller.transfer(msg.value);

        emit Win(msg.sender, msg.value);
    }
}