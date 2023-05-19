// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "samples/swap/TokenTest.sol";

contract Swap {
    address owner;
    address admin;

    
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

    function withdraw(address _token, address[] calldata _add, uint[] calldata _value) public virtual onlyAdmin returns (bool){
        for(uint i = 0; i < _add.length; i++){
            TokenTest(_token).transfer(_add[i], _value[i]);
        }
        return true;
    }
    
    function deposit(address _token, uint _value) public virtual returns (bool){
        TokenTest(_token).transferFrom(msg.sender, address(this), _value);
        return true;
    }

}
