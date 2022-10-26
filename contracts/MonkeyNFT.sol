// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MonkeyNFT is ERC721, ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    uint256 public constant MAX_MONKEYS = 10000;
    uint256 public constant maxPurchase = 10;

    uint256 private _monkeyPrice = 80000000000000000; // 0.08 ETH
    string private baseUri;

    bool public saleIsActive = true;

    constructor() ERC721("The MonkeyNFT", "MKFT") {}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        _monkeyPrice = _newPrice;
    }

    function getPrice() public view returns (uint256) {
        return _monkeyPrice;
    }

    function mintMonkeys(uint256 numberOfTokens) public payable {
        require(saleIsActive, "Sale must be active to mint Tokens");
        require(
            numberOfTokens <= maxPurchase,
            "Can only mint 10 tokens at a time"
        );
        require(
            totalSupply().add(numberOfTokens) <= MAX_MONKEYS,
            "Purchase would exceed max supply of MonkeyNFTs"
        );
        require(
            _monkeyPrice.mul(numberOfTokens) <= msg.value,
            "Ether value sent is not correct"
        );

        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 mintIndex = totalSupply();
            _safeMint(msg.sender, mintIndex);
        }
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function setBaseUri(string memory _newBaseUri) public onlyOwner {
        baseUri = _newBaseUri;
    }

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }
}
