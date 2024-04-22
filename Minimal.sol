// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnburnableToken {
    string private salt = "value"; 
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    uint256 public totalClaimed;
    mapping(address => bool) private claimed;

    // Custom errors
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address _to);

    constructor() {
        totalSupply = 100000000; // Set the total supply of tokens
    }

    // Public function to claim tokens
    function claim() public {
        if (totalClaimed >= totalSupply) revert AllTokensClaimed(); // Check if all tokens have been claimed
        if (claimed[msg.sender]) revert TokensClaimed(); // Check if the caller has already claimed tokens

        // Update balances and claimed status
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
        claimed[msg.sender] = true;
    }

    // Public function for safe token transfer
    function safeTransfer(address _to, uint256 _amount) public {
        // Check for unsafe transfer conditions, including if the target address has a non-zero ether balance
        if (_to == address(0) || _to.balance == 0) revert UnsafeTransfer(_to);

        // Ensure the sender has enough balance to transfer
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}