// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.1 ether, "Insufficient fund");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "Only manager can see balance");
        return address(this).balance;
    }

    function random() public view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);

        // uint r = random();
        // address payable winner;
        // uint index = r % players.length;
        // winner = players[index];

        //winner.transfer(getBalance());
        //players = new address payable[](0); // resetting the lottery

        // Refactor code
        uint index = random() % players.length;
        players[index].transfer(getBalance());
    }
}
