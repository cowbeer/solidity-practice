// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract ERC721 is IERC721 {
    // 某个token -> 该token的持有者
    mapping(uint => address) internal _ownerOf;
    // 某个地址 -> 该地址拥有的token数量
    mapping(address => uint) internal _balanceOf;
    // 某个token -> 可花费该token的地址
    mapping(uint => address) internal _approvals;
    //
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function balanceOf(address owner) external view returns (uint256 balance) {
        require(owner != address(0), "owner = address(0)");
        return _balanceOf[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address owner) {
        owner = _ownerOf[tokenId];
        require(owner != address(0), "owner = address(0)");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external {
        transferFrom(from, to, tokenId);
        require(
            to.code.length == 0 ||
            IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) ==
            IERC721Receiver.onERC721Received.selector,
            "unsafe recipient");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        transferFrom(from, to, tokenId);
        require(
            to.code.length == 0 ||
            IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "") ==
            IERC721Receiver.onERC721Received.selector,
            "unsafe recipient");
    }

    function _isApprovedOrOwner(address owner, address spender, uint tokenId) internal view returns(bool) {
        return (
            // token持有者和消费者相同
            spender == owner ||
            // token持有者和消费者不同，消费者有该token的授权
            spender == _approvals[tokenId] ||
            // 消费者有持有者所有token的授权
            isApprovedForAll[owner][spender]);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(from == _ownerOf[tokenId], "from != owner");
        require(to == address(0), "to = address(0)");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authorized");

        _balanceOf[from] -= 1;
        _balanceOf[to] += 1;
        _ownerOf[tokenId] = to;
        delete _approvals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) external {
        address owner = _ownerOf[tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "not authorized");
        _approvals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId) external view returns (address operator) {
        require(_ownerOf[tokenId] != address(0), "token doesn't exist");
        return _approvals[tokenId];
    }

    function _mint(address to, uint tokenId) internal {
        require(to != address(0), "to = address(0)");
        require(_ownerOf[tokenId] == address(0), "token exists");

        _balanceOf[to] +=1;
        _ownerOf[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint tokenId) internal {
        address owner = _ownerOf[tokenId];
        require(owner != address(0), "token does not exist");

        _balanceOf[owner] -=1;
        delete _ownerOf[tokenId];
        delete _approvals[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
}

contract MyNFT is ERC721 {
    function mint(address to, uint tokenId) external {
        _mint(to, tokenId);
    }

    function burn(uint tokenId) external {
        require(msg.sender == _ownerOf[tokenId], "not owner");
        _burn(tokenId);
    }
}