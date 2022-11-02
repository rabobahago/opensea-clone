//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    // importing counter from openzeppelin
    using Counters for Counters.Counter;
    //set _tokenIds to be of type Counters.Counter
    Counters.Counter private _tokenIds;
    // address of the NFT Marketplace
    address contractAddress;

    constructor(address marketplace) ERC721("rabosea token", "PNVT") {
        contractAddress = marketplace;
    }

    function createToken(string memory tokenURL) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURL);
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }
}
