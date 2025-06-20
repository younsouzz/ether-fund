// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Whitelist {
    address public owner;
    mapping(address => bool) public whitelisted;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addToWhitelist(address user) public onlyOwner {
        whitelisted[user] = true;
    }

    function removeFromWhitelist(address user) public onlyOwner {
        whitelisted[user] = false;
    }

    function isWhitelisted(address user) public view returns (bool) {
        return whitelisted[user];
    }
}
