// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/* This is a comprehensive smart contract template for :
1. Reinsurance
2. Parametric insurance
3. Risk pooling
4. Proof of insurance
5. Claims processing and settlements
*/

// Reinsurance contract
contract ReinsuranceContract is Ownable{
    address public insurer;
    address public reinsurer;
    uint256 public reinsuranceAmount;
    bool public accepted;
    
    event ReinsuranceAccepted();
    event CheckBalance(string text, uint amount);

    constructor(address _insurer, address _reinsurer, uint256 _reinsuranceAmount) {
        insurer = _insurer;
        reinsurer = _reinsurer;
        reinsuranceAmount = _reinsuranceAmount;
    }

    // The reinsurer accepts the reinsurance
    function acceptReinsurance() external onlyOwner {
        require(msg.sender == reinsurer, "Only the reinsurer can accept reinsurance");
        accepted = true;
        emit ReinsuranceAccepted();
    }
    
    function getBalance(address user_account) external returns (uint){
    
       string memory data = "User Balance is : ";
       uint user_bal = user_account.balance;
       emit CheckBalance(data, user_bal );
       return (user_bal);

    }
}

// Parametric insurance contract
contract ParametricInsuranceContract is Ownable {
    IERC20 public premiumToken; // Token for premium payments
    uint256 public premiumAmount;
    uint256 public payoutAmount;
    uint256 public expirationTime;
    bool public expired;
    bool public claimed;
    //address public policyholder;

    event InsuranceClaimed(address indexed policyholder, uint256 amount);
    event CheckBalance(string text, uint amount);

    constructor(address _premiumToken, uint256 _premiumAmount, uint256 _payoutAmount, uint256 _expirationTime) {
        premiumToken = IERC20(_premiumToken);
        premiumAmount = _premiumAmount;
        payoutAmount = _payoutAmount;
        expirationTime = _expirationTime;
    }

    // Purchase insurance policy
    function purchaseInsurance() external {
        require(block.timestamp < expirationTime, "Insurance policy has expired");
        require(!claimed, "Insurance policy has already been claimed");
        require(premiumToken.transferFrom(msg.sender, address(this), premiumAmount), "Premium payment failed");
    }

    // Claim insurance payout
    function claimInsurance(address policyholder) external {
        require(block.timestamp < expirationTime, "Insurance policy has expired");
        require(!claimed, "Insurance policy has already been claimed");
        require(msg.sender == owner() || msg.sender == policyholder, "Only the policyholder or contract owner can claim");
        require(premiumToken.transfer(owner(), payoutAmount), "Payout failed");
        claimed = true;
        emit InsuranceClaimed(msg.sender, payoutAmount);
    }

    function getBalance(address user_account) external returns (uint){
    
       string memory data = "User Balance is : ";
       uint user_bal = user_account.balance;
       emit CheckBalance(data, user_bal );
       return (user_bal);

    }
}

// Risk pooling contract
contract RiskPoolingContract is Ownable {
    IERC20 public reserveToken; // Token for pool reserves
    uint256 public totalReserveAmount;
    uint256 public totalPayouts;
    bool public closed;

    mapping(address => uint256) public contributions;
    mapping(address => uint256) public payouts;

    event ContributionAdded(address indexed contributor, uint256 amount);
    event CheckBalance(string text, uint amount);

    constructor(address _reserveToken) {
        reserveToken = IERC20(_reserveToken);
    }

    // Add contribution to the risk pool
    function addContribution(uint256 amount) external {
        require(!closed, "Risk pool is closed");
        require(amount > 0, "Contribution amount must be greater than zero");
        require(reserveToken.transferFrom(msg.sender, address(this), amount), "Contribution transfer failed");

        contributions[msg.sender] += amount;
        totalReserveAmount += amount;

        emit ContributionAdded(msg.sender, amount);
    }

    // Close the risk pool
    function closePool() external onlyOwner {
        closed = true;
    }

    // Calculate and distribute payouts
    function distributePayouts() external onlyOwner {
        // Implement logic to calculate and distribute payouts to contributors
    }

    function getBalance(address user_account) external returns (uint){
    
       string memory data = "User Balance is : ";
       uint user_bal = user_account.balance;
       emit CheckBalance(data, user_bal );
       return (user_bal);

    }
}
