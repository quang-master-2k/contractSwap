// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "samples/swap/TokenTest.sol";

contract Swap {
    address owner;
    address admin;

    struct Withdrawal {
        address add;
        uint value;     
    }

    event Withdraw(address indexed from, address indexed to, uint256 value);
    event Deposit(address indexed from, address indexed to, uint256 value);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    function approveAdmin(address _add) public onlyOwner {
        admin = _add;
    }
    
    function withdrawOwner(address _token) public virtual onlyOwner {
        TokenTest(_token).transfer(owner, TokenTest(_token).balanceOf(address(this)));
    }

    function withdraw(address _token, Withdrawal[] calldata _withdrawals) public virtual onlyAdmin {
        for(uint i = 0; i < _withdrawals.length; i++){
            require(_withdrawals[i].add != address(0), "Cannot transfer to address zero");
            require(TokenTest(_token).balanceOf(address(this)) >= _withdrawals[i].value, "Transfer amount exceed balance");
            TokenTest(_token).transfer(_withdrawals[i].add, _withdrawals[i].value);
            emit Withdraw(address(this), _withdrawals[i].add, _withdrawals[i].value);
        }

        
    }
    
    function deposit(address _token, uint _value) public virtual {
        require(TokenTest(_token).balanceOf(msg.sender) >= _value, "Transfer amount exceed balance");
        require(msg.sender != address(0), "Cannot transfer to address zero");
        require(TokenTest(_token).allowance(msg.sender, address(this)) >= _value, "Insufficient allowance");
        TokenTest(_token).transferFrom(msg.sender, address(this), _value);
        emit Deposit(msg.sender, address(this), _value);
    }

}
