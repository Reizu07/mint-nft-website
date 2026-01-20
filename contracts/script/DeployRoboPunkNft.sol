// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";
import {RoboPunksNFT} from "../src/RobotPunksNFT.sol";

contract DeployRoboPunkNft is Script {
    function run() external returns (RoboPunksNFT) {
        vm.startBroadcast();

        RoboPunksNFT roboPunksNft = new RoboPunksNFT();

        vm.stopBroadcast();

        return roboPunksNft;
    }
}
