// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OwnableLockChain.sol";

contract OwnableLockChainTest is Test {
    OwnableLockChain private lockChain;
    address private owner;
    address private user;
    bytes32 private testHash;

    function setUp() public {
        // In Foundry, address(this) is the default sender if we don't prank
        // We'll designate a simulated "owner" and "user".
        owner = address(this);
        user = address(0xBEEF);

        // Fund the user so they can pay the fee
        vm.deal(user, 1 ether);

        // Deploy the contract
        lockChain = new OwnableLockChain();
        testHash = keccak256("example_document");

        // By default, in this scenario, `address(this)` is the owner because it's passed in the constructor
    }

    function testInitialOwner() public {
        assertEq(lockChain.owner(), owner, "Owner should be the deployer");
    }

    function testInitialFee() public {
        // The initial fee is set to 0.001 Ether in the contract
        assertEq(lockChain.fee(), 0.001 ether, "Initial fee should be 0.001 ETH");
    }

    function testSetFeeByOwner() public {
        uint256 newFee = 0.002 ether;
        lockChain.setFee(newFee);
        assertEq(lockChain.fee(), newFee, "Fee should be updated by the owner");
    }

    function testSetFeeByNonOwnerShouldRevert() public {
        uint256 newFee = 0.002 ether;
        vm.prank(user); // Switch to 'user' address
        vm.expectRevert(); // `onlyOwner` should revert
        lockChain.setFee(newFee);
    }

 function testRegisterDocumentSuccess() public {
    // Get the fee first without using prank
    uint256 feeValue = lockChain.fee();

    // Now prank user and then call the function that needs msg.sender = user
    vm.prank(user);
    lockChain.registerDocument{value: feeValue}(testHash);

    (bytes32 hash, , address registrant) = lockChain.getDocumentDetails(testHash);
    assertEq(hash, testHash, "Hash should match");
    assertEq(registrant, user, "Registrant should be the user who called registerDocument");
}

    function testRegisterWithNoPaymentShouldFail() public {
        vm.prank(user);
        vm.expectRevert("Incorrect payment amount");
        lockChain.registerDocument(testHash); // no value sent
    }

    function testRegisterWithWrongPaymentShouldFail() public {
    vm.prank(user);
    vm.expectRevert(bytes("Incorrect payment amount"));
    lockChain.registerDocument{value: 0.5 ether}(testHash);
}
function testRegisterWithZeroHashShouldFail() public {
    uint256 feeValue = lockChain.fee();

    vm.prank(user);
    vm.expectRevert(bytes("Invalid document hash"));
    lockChain.registerDocument{value: feeValue}(bytes32(0));
}

    function testWithdrawFeesByNonOwnerShouldFail() public {
        // Register a doc from `user`
        vm.prank(user);
        lockChain.registerDocument{value: lockChain.fee()}(testHash);

        vm.prank(user);
        vm.expectRevert(); // onlyOwner
        lockChain.withdrawFees();
    }

    function testRenounceOwnershipDisabled() public {
        vm.expectRevert(bytes("renounceOwnership is disabled"));
        lockChain.renounceOwnership();
    }

    function testTransferOwnershipDisabled() public {
        vm.expectRevert(bytes("transferOwnership is disabled"));
        lockChain.transferOwnership(address(0xCAFE));
    }

    function testRegisterDocumentTwiceShouldFail() public {
    uint256 feeValue = lockChain.fee();

    vm.startPrank(user);
    lockChain.registerDocument{value: feeValue}(testHash);
    vm.expectRevert(bytes("Document already registered"));
    // `vm.startPrank(user)` remains active until `vm.stopPrank()` so the next call still has `msg.sender = user`
    lockChain.registerDocument{value: feeValue}(testHash);
    vm.stopPrank();
}
}
