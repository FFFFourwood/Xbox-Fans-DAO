// Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract xboxFans is ERC721Enumerable, Ownable {
    using Strings for uint256;

    bool public _isSaleActive = false; //开始mint开关
    bool public _revealed = false; //开盲盒

    // Constants
    uint256 public constant MAX_SUPPLY = 2000; //NFT总数量
    uint256 public mintPrice = 0 ether; //价格
    uint256 public maxBalance = 3; //每个用户最多拥有的该NFT的数量
    uint256 public maxMint = 3; //最大可mint数量

    string baseURI;
    string public notRevealedUri;
    string public baseExtension = ".json";

    mapping(uint256 => string) private _tokenURIs;


    //@parma initBaseURI string 包含NFT的json文件的ipfs路径
    //@parameters initNotRevealedUri string 盲盒封面的NFT的json文件的ipfs路径
    constructor(string memory initBaseURI, string memory initNotRevealedUri)
        ERC721("Xbox Fans", "XBOX-FANS")
    {
        setBaseURI(initBaseURI);
        setNotRevealedURI(initNotRevealedUri);
    }


    //mint方法
    function mintXboxFans(uint256 tokenQuantity) public payable {
        require(
            totalSupply() + tokenQuantity <= MAX_SUPPLY,
            "Sale would exceed max supply"
        );
        require(_isSaleActive, "Sale must be active to mint XboxFans");
        require(
            balanceOf(msg.sender) + tokenQuantity <= maxBalance,
            "Sale would exceed max balance"
        );
        require(
            tokenQuantity * mintPrice <= msg.value,
            "Not enough token sent"
        );
        require(tokenQuantity <= maxMint, "Can only mint 5 tokens at a time");

        _mintXboxFans(tokenQuantity);
    }

    function _mintXboxFans(uint256 tokenQuantity) internal {
        for (uint256 i = 0; i < tokenQuantity; i++) {
            uint256 mintIndex = totalSupply();
            if (totalSupply() < MAX_SUPPLY) {
                _safeMint(msg.sender, mintIndex);
            }
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (_revealed == false) {
            return notRevealedUri;
        }

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return
            string(abi.encodePacked(base, tokenId.toString(), baseExtension));
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    //only owner
    //设置mint开关
    function flipSaleActive() public onlyOwner {
        _isSaleActive = !_isSaleActive;
    }

    //开盲盒
    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    }

    //设置mint价格
    function setMintPrice(uint256 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
    }

    //设置盲盒封面json文件的ipfs路径
    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    //设置nft内容的json文件的ipfs路径
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    //不知道干啥用的 我没用过
    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    //设置用户最多拥有的该NFT的数量
    function setMaxBalance(uint256 _maxBalance) public onlyOwner {
        maxBalance = _maxBalance;
    }

    //设置每次可mint数量的最大数量
    function setMaxMint(uint256 _maxMint) public onlyOwner {
        maxMint = _maxMint;
    }

    //最重要的  提现！！！
    function withdraw(address to) public onlyOwner {
        uint256 balance = address(this).balance;
        payable(to).transfer(balance);
    }
}
