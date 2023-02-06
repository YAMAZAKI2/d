// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Wallet {
  mapping(address => uint256) public balance;
  mapping(address => bool) public isavailable;
  address payable public owner;

  event depositer(address _spender, uint256 amount);
  event withdrawer(address _withdrawer, uint256 amount);
  event transferring(address sender, address receiver, uint256 amount);

  constructor()  {
    owner = payable(msg.sender);
  }

  function deposit() public payable {
    require(msg.value > 0, "Deposit amount must be greater than 0");
    require(msg.sender != address(0), "Invalid address");
    balance[msg.sender] += msg.value;
    isavailable[msg.sender] = true;
    emit depositer(msg.sender, msg.value);
  }

  function withdraw(uint256 _amount) public payable {
    require(isavailable[msg.sender], "Account not approved for withdrawal");
    require(msg.sender != address(0), "Invalid address");
    require(balance[msg.sender] >= _amount, "Insufficient balance");
    require(_amount > 0, "Withdrawal amount must be greater than 0");

    address payable sender = payable( msg.sender);
    uint256 amount = _amount;
    balance[sender] -= amount;
    sender.transfer(_amount);
    emit withdrawer(sender, amount);
  }

  function transfer(address payable _to, uint256 _amount) public {
    require(isavailable[msg.sender], "Account not approved for withdrawal");
    require(balance[msg.sender] >= _amount, "Insufficient balance");
    require(_to != address(0) && _amount != 0, "Invalid address or amount");
    balance[msg.sender] -= _amount;
    _to.transfer(_amount);
    emit transferring(msg.sender, _to, _amount);
  }
}
