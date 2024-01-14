// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ManualToken {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    mapping(address user => uint256 amount) private s_balances;
    // holding tokens in ERC20 -> just mean we have some balance in some mapping

    function name() public pure returns (string memory) {
        return "NYCTOKEN";
    }

    function symbol() public pure returns (string memory) {
        return "NYC";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure returns (uint256) {
        return 1000e18; // 1000 ether
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 callerBalance = s_balances[msg.sender];
        if (callerBalance < _value) {
            return false;
        }
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;

        // Whenver transfer fn is called
        // msg.sender will be the caller
        // He is transfering some balance from his account to the other
        // To transfer, msg.sender balance should be greater than value
    }
}
