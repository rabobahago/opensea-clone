//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//prevent reentrancy attack
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard {
    // importing counter
    using Counters for Counters.Counter;
    //total number of items ever created track
    Counters.Counter private _itemIds;
    //total number of items ever sold track
    Counters.Counter private _itemsSold;
    //set owner address and is mark as payable because users will pay to the owner
    address payable owner;
    // price charge for them  to put their NFT in this  market place
    uint256 listingPrice = 0.025 ether;

    //constructor the run once in other to assign owner
    constructor() {
        owner = payable(msg.sender);
    }

    // struct of structure
    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
    //a way to access value of item by passing id to it
    mapping(uint256 => Marketplace) private idMarketItem;
    //log message when item is sold
    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    //function to get listingPrice
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    //function to create a market place
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
        require(price > 0, "Price most be > 0");
        require(msg.value == listingPrice, "Price most be = price");
        //increment the total number of items ever created track
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        idMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender), //seller putting nft for sale
            payable(address(0)), // no owner yet(set owner to empty address)
            price,
            false
        );
        //transfer ownership of the nft to the contract itself
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
        //log this transaction
        emit MarketItemCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );
    }

    //function to create a sale
    function createMarketSale(address nftContract, uint256 itemId)
        public
        payable
        nonReentrant
    {
        uint256 price = idMarketItem[itemId].price;
        uint256 tokenId = idMarketItem[itemId].tokenId;
        require(msg.value == price, "price not equal to the require price");
        // make payment
        idMarketItem[itemId].seller.transfer(msg.value);
        //transfer ownership of the nft from the contract itself to the buyer
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        //marker new buyer as owner
        idMarketItem[itemId].owner = payable(msg.sender);
        // mark that it has been sold
        idMarketItem[itemId].sold = true;
        //increment total number item sold by 1
        _itemsSold.increment();
        //pay owner of contract listingPrice
        payable(owner).transfer(listingPrice);
    }

    //total number of item unsold on our platform
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        //total number of items ever created in our platform
        //remember this _itemIds is gotten from Counter contract we inherited from openzeppelin
        uint256 itemCount = _itemIds.current();
        uint256 unsoldItemCount = _itemIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;
        // create an array of all items
        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        //loop through all items
        for (uint256 i = 0; i < itemCount; i++) {
            //get unsold item
            //checked if this item has not been sold
            //by checking if the owner is empty
            if (idMarketItem[i + 1].owner == address(0)) {
                //the item hasn't been sold
                uint256 currentId = idMarketItem[i + 1].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    //fetch list of NFT owner/bought by this user
    function fetchMyNNFs() public view returns (MarketItem[] memory) {
        //get total number of item ever created
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;
        for (uint i = 0; i < totalItemCount; i++) {
            //get only the item that this user has bought/is the owner
            if (idMarketItem[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint i = 0; i < totalItemCount; i++) {
            if (idMarketItem[i + 1].owner == msg.sender) {
                uint currentId = idMarketItem[i + 1].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
