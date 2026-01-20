//SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping(address => uint256) public walletMints;

    constructor() payable ERC721("RoboPunks", "RP") Ownable(msg.sender) {
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
        // set withdraw wallet address
    }

    function setIsPublicMintEnabled(
        bool isPublicMintEnabled_
    ) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function setbaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }

    function setWithdrawWallet(
        address payable withdrawWallet_
    ) external onlyOwner {
        withdrawWallet = withdrawWallet_;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist!");
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(tokenId),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{value: address(this).balance}(
            ""
        );
        require(success, "Withdrawal failed");
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, "Minting is not enabled");
        require(msg.value == quantity_ * mintPrice, "Wrong mint value");
        require(totalSupply + quantity_ <= maxSupply, "Exceeds max supply");
        require(
            walletMints[msg.sender] + quantity_ <= maxPerWallet,
            "Exceeds max per wallet"
        );

        for (uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
            walletMints[msg.sender]++;
        }
    }
}
