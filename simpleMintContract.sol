// SPDX_License_Identifier: Unlicense
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract SimpleMintContract is ERC721, Ownable {
    //vars
    uint256 public mintPrice = 0.05 ether;
    uint256 public totalSupply; 
    uint256 public maxSupply; 

    bool public isMintEnabled; 
    mapping (address=>uint256) public mintedWallets; 
    
    //funcs
    constructor () payable ERC721('Simple Mint', 'SIMPLEMINT'){ 
        maxSupply = 2; 
    }

    function toggleIsMintEnable() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }


    function setMaxSupply(uint256 maxSupply_) external onlyOwner {
        maxSupply = maxSupply_; 
    }

    function mint() external payable { 
        require(isMintEnabled, 'minting not enabled');
        require(mintedWallets[msg.sender]<1, 'exceed max per wallet'); //track the number of nft has minted
        require(msg.value == mintPrice, 'wrong value');
        require(maxSupply > totalSupply, 'sold out');

        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;     //save some gas
        _safeMint(msg.sender, tokenId);
    }

}
