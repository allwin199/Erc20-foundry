// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Creating ERC20 contract using openzeppelin
/// @author Prince Allwin
/// @notice Since ERC20 is inherited, all ERC20 methods are accessible to this contract
contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("My Token", "MTK") {
        _mint(msg.sender, initialSupply);
    }
}
// Eventhough This contract dosen't have any function
// Just by inheriting ERC20, all ERC20 methods will be accessible only we deploy this contract
// eg: transfer(), balanceOf() ...
