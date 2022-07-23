// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

// Import this file to use console.log
import "hardhat/console.sol";

contract SVGNFT is ERC721URIStorage {
    uint256 public tokenCounter; //to keep track of the number of tokens created

    constructor() ERC721("SVG NFT", "svgNft") {
        tokenCounter = 0; //initialize the token counter to 0
    }

    function create(string memory svg) public {
        _safeMint(msg.sender, tokenCounter); //mint the token to the sender
        string memory imageURI = svgToImageURI(svg); //convert the svg to an image URI

        tokenCounter = tokenCounter + 1; //increment the token counter
    }

    // svgToImageURI converts the svg to an image URI using base64-sol library and returns the image URI as a string memory
    function svgToImageURI(string memory svg)
        public
        pure
        returns (string memory)
    {
        //         <svg xmlns="http://www.w3.org/2000/svg" height="210" width="400">
        //   <path d="M150 0 L75 200 L225 200 Z" />
        // </svg>
        //data:image/svg+xml;base64,<Base65-encoding>
        string memory baseURL = "data:image/svg+xml;base64,"; //base URL for the image
        string memory svgBase64Encoded = Base64.encode( //encode the svg string to base64
            bytes(string(abi.encodePacked(svg))) //encode the svg string as a byte array
        );

        //string uri = baseURL + svgBase64Encoded;
        string memory imageURI = string(
            abi.encodePacked(baseURL, svgBase64Encoded) //encode the base64 encoded svg string
        ); //concatenate the baseURL and the svgBase64Encoded string

        return imageURI; //return the image URI
    }
}
