//SPDX-license-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/be3cfa0f9068a1495dc524975209f223da20e148/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/be3cfa0f9068a1495dc524975209f223da20e148/contracts/utils/Counters.sol";

contract breakouts001 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    bool private revealed = false;
    string private revealUrl = "https://gateway.pinata.cloud/ipfs/QmaMZi7nrogP6HsG877Eyv1s6Sj3h7hgiLzR1sPL2hEgF3";
modifier ownerme(){
    require (msg.sender == 0xbA155f49B035DcC34AC64243C00a85EB33ad8AaB);
    _;
}
modifier checkprice(){
        require (msg.value >= 0.1 ether );
        _;}

string public AtokenURI = "https://gateway.pinata.cloud/ipfs/QmaMZi7nrogP6HsG877Eyv1s6Sj3h7hgiLzR1sPL2hEgF3";
string public BtokenURI = "";


    struct Voter{  
        bool voted; 
        uint weight; 
    }
    struct Own{
        address owneraddress;
    }
     //mapping(uint => address) public _owners;

    
    //投票者マッピング
    mapping(address => Voter) public voters;

    
    constructor() ERC721("breakouts001", "BO1") public {
    }
    uint  keccack256edpass = 528;

    function mintNFT(uint  pass) public payable  returns (uint256) {
        require(keccak256(abi.encodePacked(pass)) == keccak256(abi.encodePacked(keccack256edpass)),"you can not mint NFT");
        Voter storage sender = voters[msg.sender];
        require( !sender.voted); 
        
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        //require (msg.value == 1 ether);
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, AtokenURI);
        
        sender.voted = true;
        return newItemId;
    }

    function mintNFTx(uint pass) public payable checkprice returns (uint256) {
         require(keccak256(abi.encodePacked(pass)) == keccak256(abi.encodePacked(keccack256edpass)),"you can not mint NFT");
        _tokenIds.increment();
        Voter storage sender = voters[msg.sender];
        uint256 newItemId = _tokenIds.current();
        require(  !sender.voted ); 
        require (msg.value == 1 ether);
        _mint(msg.sender, newItemId);
        address to = msg.sender;
        //    _owners[newItemId] = to;
             emit Transfer(address(0), to, newItemId);
             _afterTokenTransfer(address(0), to, newItemId);
        _setTokenURI(newItemId, AtokenURI);
        
        sender.voted = true;
        return newItemId;
    }




    function burnNFT(uint tokenId) public payable {
     //   address owner = _owners[tokenId];
	//require(owner != address(0), "ERC721: owner query for nonexistent token");
    require (ERC721.ownerOf(tokenId) == msg.sender);
        _burn(tokenId);
        //delete _owners[tokenId];
        
        msg.sender.call{value: 0.1 ether}("");

    }

    function tokenURI(uint256 tokenId) public view virtual override returns(string memory){
        if (revealed == true){
            return super.tokenURI(tokenId);
        }else{
            return revealUrl;
        }
    }
    function revealColletion() public ownerme{
        revealed = true;
    }
     function withdraw( uint _amount) public {
        (bool success, ) = 0xbA155f49B035DcC34AC64243C00a85EB33ad8AaB.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}



// SPDX-License-Identifier: MIT
// Modified from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/utils/cryptography/MerkleProof.sol
// Copied from https://github.com/ensdomains/governance/blob/master/contracts/MerkleProof.sol

pragma solidity ^0.8.11;

/**
 * @dev These functions deal with verification of Merkle Trees proofs.
 *
 * The proofs can be generated using the JavaScript library
 * https://github.com/miguelmota/merkletreejs[merkletreejs].
 * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
 *
 * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
 *
 * Source: https://github.com/ensdomains/governance/blob/master/contracts/MerkleProof.sol
 */
library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool, uint256) {
        bytes32 computedHash = leaf;
        uint256 index = 0;

        for (uint256 i = 0; i < proof.length; i++) {
            index *= 2;
            bytes32 proofElement = proof[i];

            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
                index += 1;
            }
        }

        // Check if the computed hash (root) is equal to the provided root
        return (computedHash == root, index);
    }
}
