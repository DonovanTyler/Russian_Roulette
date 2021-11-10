pragma solidity >=0.7.0 <0.9.0;

contract Auction_System {
    
}
contract WinAuction{
    event Win(address winner, uint256 amount);
    IERC721 public immutable nft;
    uint public immutable nftID;
    constructor (address _nft, _nftId) {
        seller = payable(msg.sender);
        nft = IERC721(_nft);
        nftId = _nftId;
    }
    function win() external payable {
        winner = msg.sender;
        nft.transferFrom(seller, msg.sender, nftId);
        seller.transfer(msg.value);
        
        emit Win(msg.sender, msg.value);
    }
}