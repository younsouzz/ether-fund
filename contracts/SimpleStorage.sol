// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    uint256 private storedData;

    event DataChanged(uint256 newValue);

    function set(uint256 x) public {
        storedData = x;
        emit DataChanged(x);
    }

    function get() public view returns (uint256) {
        return storedData;
    }
}
