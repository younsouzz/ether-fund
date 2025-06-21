// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TimeLock {
    address public owner;
    uint256 public unlockTime;

    constructor(uint256 _unlockTime) payable {
        require(_unlockTime > block.timestamp, "Unlock time should be in the future");
        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    function withdraw() public {
        require(block.timestamp >= unlockTime, "Too early");
        require(msg.sender == owner, "Not owner");

        payable(owner).transfer(address(this).balance);
    }

    function getTimeLeft() public view returns (uint256) {
        if (block.timestamp >= unlockTime) return 0;
        return unlockTime - block.timestamp;
    }

    receive() external payable {}
}
