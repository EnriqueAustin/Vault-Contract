// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    mapping(address => uint256) public balances;
    address[] public wallets;
    uint256 public totalBalance;
    uint256 public numberOfWallets;

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
        bool exists = false;
        for (uint256 i = 0; i < wallets.length; i++) {
            if (wallets[i] == msg.sender) {
                exists = true;
            }
        }
        if (!exists) {
            wallets.push(msg.sender);
            numberOfWallets++;
        }
    }

    function distribute() public {
        require(totalBalance > 0, "There is no balance to distribute");
        uint256 share = totalBalance / numberOfWallets;
        for (uint256 i = 0; i < wallets.length; i++) {
            balances[wallets[i]] += share;
        }
        totalBalance = 0;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "You have no balance to withdraw");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        totalBalance -= amount;
        payable(msg.sender).transfer(amount);
    }
}
