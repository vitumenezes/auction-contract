pragma solidity ^0.4.25;

import "./erc721.sol";
import "./leilao_storage.sol";

contract LeilaoToken is LeilaoStorage, ERC721 {
    
    mapping (uint256 => address) tokenApprovals;
    
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerTokenCount[_owner];
    }
    
    function _ownerOf(uint256 _tokenId) private view returns (address _owner) {
        return _tokenOwner[_tokenId];
    }
    
    function transfer(address _to, uint256 _tokenId) public {
        _transfer(this, _to, _tokenId);
    }
    
    function _transfer(address _from, address _to, uint256 _tokenId) private onlyOwnerOfToken(_from, _tokenId) {
        ownerTokenCount[_to]++;
        ownerTokenCount[_from]--;
        _tokenOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
    
    function approve(address _to, uint256 _tokenId) public onlyOwnerOfToken(msg.sender, _tokenId) {
        tokenApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }
    
    function takeOwnership(uint256 _tokenId) public {
        require(tokenApprovals[_tokenId] == msg.sender);
        address owner = _ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }
}

