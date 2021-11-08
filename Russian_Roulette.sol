pragma solidity >=0.7.0 <0.9.0;

contract Russian_Roulette {
    address[] players;
    mapping (address => bool) public losers;
    uint256 playersSize;
    uint256 odds;
    uint256 playersTurn = 1;
    address creator;
    
    constructor (address contractCreator) public {
        creator = contractCreator;
    }
    
    function setOdds(uint oneInThisMany) public {
        require(msg.sender == creator);
        odds = oneInThisMany;
        }
        
    function addPlayer(address player) public {
        require(!isALoser(player));
        require(!playersContains(player));
        playersSize++;
        players[playersSize] = player;
    }
    function lose(address player) internal {
       losers[player] = true;
        delete(players);
        playersSize = players.length;
    }
    
    function play() public {
        uint256 randomNum = random();
        address currentPlayer = players[playersTurn];
        if(randomNum == 1){
            lose(currentPlayer);
        }
        else {
            if(playersTurn == playersSize) {
                playersTurn = 1;
            }
            else {
                playersTurn++;
            }
        }
        
    }
    
    function random() internal returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%odds + 1;
    }
    
    function isALoser(address player) public returns (bool){
       return losers[player];
    }
    
    function playersContains(address test) internal returns (bool) {
        for(uint256 i = 0; i< players.length; i++){
            if(players[i] == test){
                return true;
            }
        }
        return false;
    }
}