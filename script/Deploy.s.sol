// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
// ../../LockChainProject/lib/forge-std/src/Script.sol
import "../src/OwnableLockChain.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract
        OwnableLockChain ownableLockChain = new OwnableLockChain();

        console.log("Contract deployed at:", address(ownableLockChain));

        vm.stopBroadcast();
    }
}
