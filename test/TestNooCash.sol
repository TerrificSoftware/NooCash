pragma solidity ^0.4.4;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NooCash.sol";

contract TestNooCash {

  function testTotalSupply() 
  {
    NooCash token = NooCash(DeployedAddresses.NooCash());

    uint256 expected = 0;
    Assert.equal(token.totalSupply(), expected, "totalSupply should be 0 tokens initially");
  }

  function testInitialBalance() 
  {
    NooCash token = NooCash(DeployedAddresses.NooCash());

    uint256 expected = 0;
    Assert.equal(token.balanceOf(tx.origin), expected, "Owner should have 0 tokens initially");
  }

  function testMaxSupply() 
  {
    NooCash token = NooCash(DeployedAddresses.NooCash());

    uint256 expected = 10000000e18;
    Assert.equal(token.maxSupply(), expected, "maxSupply should be 10 Million tokens (plus 18 decimals) initially");
  }

  function testIncreaseMaxSupply() 
  {
    NooCash token = NooCash(DeployedAddresses.NooCash());

    token.increaseMaxSupply(10000000e18);
    uint256 expected = 20000000e18;
    Assert.equal(token.maxSupply(), expected, "maxSupply should be 20 Million tokens now");
  }

  function testMint()
  {
    NooCash token = NooCash(DeployedAddresses.NooCash());
    address beneficiary = address("0x87bBE22bB1c931FC685eD029a5ec7915e5f86aAa");

    token.mint(beneficiary, 50e18); //50e18, or 50 full tokens
    uint256 expected = 50e18;

    Assert.equal(token.balanceOf(beneficiary), expected, "Beneficiary should have 50 tokens");
    Assert.equal(token.totalSupply(), expected, "totalSupply should be 50 tokens");
  }

}