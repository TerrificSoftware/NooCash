pragma solidity ^0.4.11;

import './BasicCrowdsale.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title NooCashCrowdsale
 * @dev A crowdsale for an already-deployed token. 
 * Allows setting the initial rate in the constructor.
 */
contract NooCashCrowdsale is BasicCrowdsale {
    using SafeMath for uint256;

    // same as the constructor for BasicCrowdsale, with addition of _tokensPerEth parameter
    function NooCashCrowdsale(address _token, uint256 _startTime, uint256 _endTime, uint256 _tokensPerEth, address _wallet) {
        require(_token != 0x0);
        require(_startTime >= now);
        require(_endTime >= _startTime);
        require(_tokensPerEth > 0);
        require(_wallet != 0x0);

        token = _token;
        startTime = _startTime;
        endTime = _endTime;
        tokensPerEth = _tokensPerEth;
        wallet = _wallet;
    }
}