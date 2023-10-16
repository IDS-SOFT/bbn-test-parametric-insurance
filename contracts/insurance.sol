// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/* This is a comprehensive smart contract template for :
1. Reinsurance
2. Parametric insurance
3. Risk pooling
4. Proof of insurance
5. Claims processing and settlements
*/

contract ParametricInsuranceContract {
    address owner;

    IERC20 public premiumToken; // Token for premium payments
    uint256 public premiumAmount;
    uint256 public payoutAmount;
    uint256 public expirationTime;
    bool public expired;
    bool public claimed;
    //address public policyholder;

    event InsuranceClaimed(address indexed policyholder, uint256 amount);
    event CheckBalance(uint amount);

    constructor(address _premiumToken, uint256 _premiumAmount, uint256 _payoutAmount, uint256 _expirationTime) {
        premiumToken = IERC20(_premiumToken);
        premiumAmount = _premiumAmount;
        payoutAmount = _payoutAmount;
        expirationTime = _expirationTime;
        owner = msg.sender;
    }

    // Purchase insurance policy
    function purchaseInsurance() external {
        require(block.timestamp < expirationTime, "Insurance policy has expired");
        require(!claimed, "Insurance policy has already been claimed");
        require(premiumToken.transferFrom(msg.sender, address(this), premiumAmount), "Premium payment failed");
    }

    // Claim insurance payout
    function claimInsurance(address policyholder) external {
        require(policyholder != address(0), "Invalid address");
        require(block.timestamp < expirationTime, "Insurance policy has expired");
        require(!claimed, "Insurance policy has already been claimed");
        require(msg.sender == owner() || msg.sender == policyholder, "Only the policyholder or contract owner can claim");
        require(premiumToken.transfer(owner(), payoutAmount), "Payout failed");

        claimed = true;
        emit InsuranceClaimed(msg.sender, payoutAmount);
    }

    function getBalance(address user_account) external returns (uint){
       uint user_bal = user_account.balance;
       emit CheckBalance(user_bal);
       return (user_bal);
    }
}
