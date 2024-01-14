// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    MyToken myToken;
    uint256 private constant INITIAL_SUPPLY = 1000e18;

    function run() external returns (MyToken) {
        vm.startBroadcast();
        myToken = new MyToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return myToken;
    }
}
