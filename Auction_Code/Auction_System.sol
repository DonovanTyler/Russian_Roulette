pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction_System {
    
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

    // Winds the auction for the specified amount
    function win() external payable {
        winner = msg.sender;
        nft.safeTransferFrom(seller, msg.sender, nftId);
        seller.transfer(msg.value);

        emit Win(msg.sender, msg.value);
    }
}