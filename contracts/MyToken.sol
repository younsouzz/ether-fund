// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title MyToken - Simple ERC20 Token Implementation
/// @author You
/// @notice Basic ERC20 token example with minting capability
contract MyToken {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    /// Events as per ERC20 standard
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Constructor that gives msg.sender all initial tokens
    /// @param initialSupply The total initial supply of tokens (in whole units, before decimals)
    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 10 ** decimals;
        balances[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// @notice Get the token balance of an address
    /// @param account The address to query
    /// @return balance The balance of the given address
    function balanceOf(address account) public view returns (uint256 balance) {
        return balances[account];
    }

    /// @notice Transfer tokens to another address
    /// @param to Recipient address
    /// @param amount Number of tokens to transfer
    /// @return success Whether the transfer succeeded
    function transfer(address to, uint256 amount) public returns (bool success) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Transfer to zero address");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /// @notice Approve an address to spend tokens on your behalf
    /// @param spender The address allowed to spend
    /// @param amount The max amount allowed
    /// @return success Whether the approval succeeded
    function approve(address spender, uint256 amount) public returns (bool success) {
        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /// @notice Check the remaining allowance an address has to spend
    /// @param owner Token owner address
    /// @param spender Spender address
    /// @return remaining Remaining allowance
    function allowance(address owner, address spender) public view returns (uint256 remaining) {
        return allowances[owner][spender];
    }

    /// @notice Transfer tokens on behalf of another address
    /// @param from The address to send tokens from
    /// @param to The recipient address
    /// @param amount Number of tokens to transfer
    /// @return success Whether the transfer succeeded
    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
        require(balances[from] >= amount, "Insufficient balance");
        require(allowances[from][msg.sender] >= amount, "Allowance exceeded");
        require(to != address(0), "Transfer to zero address");

        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }
}
