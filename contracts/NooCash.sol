pragma solidity ^0.4.11;

import "../node_modules/zeppelin-solidity/contracts/token/PausableToken.sol";
import "../node_modules/zeppelin-solidity/contracts/token/MintableToken.sol";
import "./BurnableToken.sol";

contract NooCash is BurnableToken, PausableToken, MintableToken {

    string public name = "NooCash";
    string public symbol = "NOOC";
    uint public decimals = 18;

    /* Initial supply to be owned by this contract, if any */
    uint256 public initialSupply = 0; // at the start, there are no tokens yet

    /* The maximum number of tokens that can ever be in circulation. */
    uint256 public maxSupply = 10000000e18; // 10 million tokens max

    function NooCash() {
        totalSupply = 0;
    }

    /* To allow for future inflation, and/or development needs. */
    /* Any increases will be publicized and submitted to the community for feedback and approval. */
    function increaseMaxSupply(uint256 additionalSupply) public onlyOwner {
        require(additionalSupply > 0);
        maxSupply = maxSupply.add(additionalSupply);
    }
}