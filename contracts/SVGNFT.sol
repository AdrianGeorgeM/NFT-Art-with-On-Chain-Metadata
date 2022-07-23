// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

// Import this file to use console.log
import "hardhat/console.sol";

contract SVGNFT is ERC721URIStorage {
    uint256 public tokenCounter; //to keep track of the number of tokens created
    event CreateSVGNFT(uint256 indexed tokenId, string indexed tokenURI);

    constructor() ERC721("SVG NFT", "svgNft") {
        tokenCounter = 0; //initialize the token counter to 0
    }

    function create(string memory _svg) public {
        _safeMint(msg.sender, tokenCounter); //mint the token to the sender
        string memory imageURI = svgToImageURI(_svg); //convert the svg to an image URI
        string memory tokenURI = formatTokenURI(imageURI); //format the token URI using the image URI as the token ID and the token counter as the token index
        _setTokenURI(tokenCounter, tokenURI); //set the token URI
        emit CreateSVGNFT(tokenCounter, tokenURI);
        tokenCounter = tokenCounter + 1; //increment the token counter
    }

    // svgToImageURI converts the svg to an image URI using base64-sol library and returns the image URI as a string memory
    function svgToImageURI(string memory _svg)
        public
        pure
        returns (string memory)
    {
        //         <_ xmlns="http://www.w3.org/2000/svg" height="210" width="400">
        //   <path d="M150 0 L75 200 L225 200 Z" />
        // </_>
        //data:image/svg+xml;base64,<Base65-encoding>
        string memory baseURL = "data:image/svg+xml;base64,"; //base URL for the image
        string memory svgBase64Encoded = Base64.encode( //encode the svg string to base64
            bytes(string(abi.encodePacked(_svg))) //encode the svg string as a byte array
        );

        //string uri = baseURL + svgBase64Encoded;
        string memory imageURI = string(
            abi.encodePacked(baseURL, svgBase64Encoded) //encode the base64 encoded svg string
        ); //concatenate the baseURL and the svgBase64Encoded string

        return imageURI; //return the image URI
    }

    function formatTokenURI(
        string memory _imageURI //format the token URI using the image URI as the token ID and the token counter as the token index and return the token URI as a string memory (tokenURI = baseURI + imageURI)
    ) public pure returns (string memory) {
        string memory baseURL = "data:application/json:base64"; //base URL for the image
        return
            string( //concatenate the token id and the image URI
                abi.encodePacked( //encode the image URI as a byte array
                    baseURL, //encode the baseURL as a byte array
                    Base64.encode( //encode the token id as a byte array
                        bytes( //encode the token id as a byte array
                            abi.encodePacked(
                                '{"name":"', // name of the token
                                "SVG NFT", // You can add whatever name here
                                '", "description":"An NFT based on SVG!", "attributes":"", "image":"', // attributes of the token
                                _imageURI, // image URI
                                '"}'
                            )
                        )
                    )
                )
            );
        //is return the json string in something like this:
        //data:application/json:base64,eyJtYW5pZmVzdCI6IkFuIE5UQSBieSBTVkcgTlRFUyIsImF0dHJpYnV0ZXMiOiJ9LCJpbWFnZSI6Imh0dHBzOi8vYXBwbGljYXRpb25zLnN2Z2FtZS5jb20vYXBwbGljYXRpb25zL3N2Zy9zdmcxLnN2ZyJ9
    }
}
