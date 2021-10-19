pragma solidity >=0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    address public owner;
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;

    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    address[] public stakers;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // 1. Stake Tokens (Deposit)
    function stakeTokens(uint256 _amount) public {
        require(_amount > 0, "amount cannot be less than or equal to 0");
        // Transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update staking balance
        stakingBalance[msg.sender] += _amount;

        // Add user to stakers array *only if they haven't staked already*
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Update Staking Status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // 2. Issuing Tokens
    function issueTokens() public {
        // Only Owner can call this function
        require(msg.sender == owner, "caller must be owner");

        // Issue tokens to stakers
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint256 balance = stakingBalance[recipient];
            if (balance > 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }

    // 3. Unstaking Tokens (Withdraw)
}
