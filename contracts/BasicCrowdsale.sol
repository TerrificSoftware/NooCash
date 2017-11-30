pragma solidity ^0.4.11;

import './AbstractMintableToken.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
//import '../node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title BasicCrowdsale
 * @dev A crowdsale for an already-deployed token.
 * Crowdsales have start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH tokensPerEth. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract BasicCrowdsale is Ownable {
    using SafeMath for uint256;

    // The token being sold
    address public token;

    // start and end timestamps where investments are allowed (both inclusive)
    uint256 public startTime;
    uint256 public endTime;

    // address where funds are collected
    address public wallet;

    // how many token units a buyer gets per wei
    uint256 public tokensPerEth = 1500; // defaults to 1500 NOOC per ETH

    // amount of raised money in wei
    uint256 public weiRaised;

    /**
    * event for token purchase logging
    * @param purchaser who paid for the tokens
    * @param beneficiary who got the tokens
    * @param value weis paid for purchase
    * @param amount amount of tokens purchased
    */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    function BasicCrowdsale(address _token, uint256 _startTime, uint256 _endTime, address _wallet) {
        require(_token != 0x0);
        require(_startTime >= now);
        require(_endTime >= _startTime);
        require(_wallet != 0x0);

        token = _token;
        startTime = _startTime;
        endTime = _endTime;
        wallet = _wallet;
    }

    // fallback function can be used to buy tokens
    function () payable {
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address beneficiary) public payable {
        require(beneficiary != 0x0);
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(tokensPerEth);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        AbstractMintableToken(token).mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        bool withinPeriod = now >= startTime && now <= endTime;
        bool nonZeroPurchase = msg.value != 0;
        return withinPeriod && nonZeroPurchase;
    }

    // @return true if crowdsale event has ended
    function hasEnded() public constant returns (bool) {
        return now > endTime;
    }

    function changeRate(uint256 _nooRate) public onlyOwner {
        require(_nooRate > 0 && _nooRate < 10000000);
        tokensPerEth = _nooRate;
    }
}