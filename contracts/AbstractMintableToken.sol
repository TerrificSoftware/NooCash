pragma solidity ^0.4.11;

contract AbstractMintableToken {

    string public name;
    string public symbol;
    uint public decimals;
    uint256 public totalSupply;
    uint256 public initialSupply;
    uint256 public maxSupply; 

    function balanceOf(address who) public constant returns (uint value);
    function transfer(address _to, uint256 _value) public returns (bool);
    function mint(address _to, uint256 _amount) public returns (bool);
}