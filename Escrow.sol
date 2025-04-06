// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    address public payer;
    address public payee;
    uint public amount;
    bool public isApproved;

    constructor(address _payee) payable {
        payer = msg.sender;
        payee = _payee;
        amount = msg.value;
        isApproved = false;
    }

    function approve() external {
        require(msg.sender == payer, "Only payer can approve");
        require(!isApproved, "Already approved");
        isApproved = true;
        payable(payee).transfer(amount);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
