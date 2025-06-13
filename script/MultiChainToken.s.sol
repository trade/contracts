// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/tokens/MultiChainToken.sol";
import "../src/proxy/MultiChainTokenProxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/**
 * @title MultiChainTokenScript
 * @dev Deployment script for MultiChainToken
 */
contract DeployMultiChainToken is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy standard token
        MultiChainToken token = new MultiChainToken(
            "Multi Chain Token",
            "MCT",
            1000000 * 10 ** 18 // 1 million tokens with 18 decimals
        );

        vm.stopBroadcast();
    }
}

/**
 * @title DeployMultiChainTokenProxy
 * @dev Deployment script for upgradeable MultiChainToken
 */
contract DeployMultiChainTokenProxy is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy implementation
        MultiChainTokenProxy implementation = new MultiChainTokenProxy();

        // Encode initialization data
        bytes memory initData = abi.encodeWithSelector(
            MultiChainTokenProxy.initialize.selector,
            "Multi Chain Token",
            "MCT",
            1000000 * 10 ** 18 // 1 million tokens with 18 decimals
        );

        // Deploy proxy
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);

        // The proxy address is what users will interact with
        MultiChainTokenProxy tokenProxy = MultiChainTokenProxy(address(proxy));

        vm.stopBroadcast();
    }
}
