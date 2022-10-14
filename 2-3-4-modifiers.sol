// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
 * @title Mappings' contract
 * @author Famus
 * @notice Storing user's funds, superior to predefined fee & allowlist, only letting predefined owner to withdraw
 */

contract userBalance {
    address public owner;

    // Fee definition to add new funds by allowed addresses
    uint private constant fee = 100;

    mapping(address => uint) public userbal; // mapping storing user's balance

    uint public fundsRemoved; //funds withdrawn by the owner

    address[] public balArray; // array of depositors' addresses

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You cannot withdraw the funds");
        _;
    }

    //checking if an address has deposited funds in our mapping using the deposit function
    modifier onlyDepositor() {
        require(arrayChecker(), "Deposit first and try again");
        _;
    }

    //modifier checking if the amount to be deposited is superior to fee and 0
    modifier feeMod(uint _amount) {
        require(_amount > fee, "Amount too small");
        _;
    }

    function deposit(uint _amount) external {
        userbal[msg.sender] += _amount;
        balArray.push(msg.sender);
    }

    function checkBalance() external view returns (uint) {
        //returning whoever is calling the function balance
        return userbal[msg.sender];
    }

    //function allowing to check if an address has funds deposited in the mapping
    function arrayChecker() internal view returns (bool) {
        uint i;
        for (i = 0; i < balArray.length; i++) {
            if (balArray[i] == msg.sender && balArray[i] != address(0)) {
                return true;
            }
        }
        return false;
    }

    //function allowing depositors to add funds, if superior to a predefined fee
    function addFund(uint _amount) external onlyDepositor feeMod(_amount) {
        userbal[msg.sender] += _amount;
    }

    //Withdraw function allowing only the owner to remove funds stored in userbal mapping
    function withdraw() external onlyOwner {
        uint i = 0;
        for (i = 0; i < balArray.length; i++) {
            fundsRemoved += userbal[balArray[i]];
            userbal[balArray[i]] = 0;
            delete balArray[i];
        }
    }
}
