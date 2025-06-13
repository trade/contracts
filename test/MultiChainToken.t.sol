// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/tokens/MultiChainToken.sol";
import "../src/proxy/MultiChainTokenProxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract MultiChainTokenTest is Test {
    MultiChainToken public token;
    MultiChainTokenProxy public implementation;
    MultiChainTokenProxy public tokenProxy;

    address public owner = address(1);
    address public user = address(2);
    address public bridgeOperator = address(3);

    uint256 public initialSupply = 1000000 * 10 ** 18; // 1 million tokens
    uint256 public testAmount = 1000 * 10 ** 18; // 1000 tokens
    uint256 public testChainId = 31337; // Hardhat/Anvil chain ID
    uint256 public otherChainId = 1; // Ethereum Mainnet

    function setUp() public {
        vm.startPrank(owner);

        // Deploy standard token
        token = new MultiChainToken("Multi Chain Token", "MCT", initialSupply);

        // Deploy upgradeable token
        implementation = new MultiChainTokenProxy();

        bytes memory initData = abi.encodeWithSelector(
            MultiChainTokenProxy.initialize.selector, "Multi Chain Token Upgradeable", "MCTU", initialSupply
        );

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);

        tokenProxy = MultiChainTokenProxy(address(proxy));

        // Setup roles
        token.grantRole(token.BRIDGE_ROLE(), bridgeOperator);
        tokenProxy.grantRole(tokenProxy.BRIDGE_ROLE(), bridgeOperator);

        // Transfer some tokens to user
        token.transfer(user, testAmount);
        tokenProxy.transfer(user, testAmount);

        vm.stopPrank();
    }

    function testInitialState() public {
        assertEq(token.name(), "Multi Chain Token");
        assertEq(token.symbol(), "MCT");
        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(owner), initialSupply - testAmount);
        assertEq(token.balanceOf(user), testAmount);

        assertEq(tokenProxy.name(), "Multi Chain Token Upgradeable");
        assertEq(tokenProxy.symbol(), "MCTU");
        assertEq(tokenProxy.totalSupply(), initialSupply);
        assertEq(tokenProxy.balanceOf(owner), initialSupply - testAmount);
        assertEq(tokenProxy.balanceOf(user), testAmount);
    }

    function testBridgeTokens() public {
        vm.startPrank(user);

        // Test standard token
        token.bridgeTokens(testAmount, otherChainId);
        assertEq(token.balanceOf(user), 0);

        // Test upgradeable token
        tokenProxy.bridgeTokens(testAmount, otherChainId);
        assertEq(tokenProxy.balanceOf(user), 0);

        vm.stopPrank();
    }

    function testReceiveTokens() public {
        vm.startPrank(bridgeOperator);

        // Test standard token
        token.receiveTokens(user, testAmount, otherChainId);
        assertEq(token.balanceOf(user), testAmount * 2);

        // Test upgradeable token
        tokenProxy.receiveTokens(user, testAmount, otherChainId);
        assertEq(tokenProxy.balanceOf(user), testAmount * 2);

        vm.stopPrank();
    }

    function testPause() public {
        vm.startPrank(owner);

        // Test standard token
        token.pause();
        vm.expectRevert();
        vm.prank(user);
        token.transfer(owner, testAmount);
        token.unpause();

        // Test upgradeable token
        tokenProxy.pause();
        vm.expectRevert();
        vm.prank(user);
        tokenProxy.transfer(owner, testAmount);
        tokenProxy.unpause();

        vm.stopPrank();
    }

    function testFailBridgeToSameChain() public {
        vm.prank(user);
        token.bridgeTokens(testAmount, testChainId);
    }

    function testFailReceiveFromSameChain() public {
        vm.prank(bridgeOperator);
        token.receiveTokens(user, testAmount, testChainId);
    }
}
