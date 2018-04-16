    pragma solidity ^0.4.16;
    
    /**
     * @title SafeMath
     * @dev Math operations with safety checks that throw on error
     */
    library SafeMath {
      function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
      }
    
      function div(uint256 a, uint256 b) internal constant returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
      }
    
      function sub(uint256 a, uint256 b) internal constant returns (uint256) {
        assert(b <= a);
        return a - b;
      }
    
      function add(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
      }
      
    }
    
    /**
     * @title Crowdsale
     * @dev Crowdsale is a base contract for managing a token crowdsale.
     * Crowdsales have a start and end timestamps, where investors can make
     * token purchases and the crowdsale will assign them tokens based
     * on a token per ETH rate. Funds collected are forwarded to a wallet
     * as they arrive.
     */
    contract token { function transfer(address receiver, uint amount){  } }
    contract StealthDistribution {
      using SafeMath for uint256;
      
      struct Funder {
            address addr;
            uint noOfToken;
       }
       
       Funder[] public funder;
    
    
      
      address public addressOfTokenUsedAsReward;
      token tokenReward;
    
      
      address public creator;
      bool public crowdsaleIsActive = true;
      mapping(address => uint256) public balanceOf;
      
      bool public crowdsaleClosed = false;
      bool public allocated = false;
      
      
      modifier isCreator(){
        require(msg.sender == creator) ;
        _;
      }
      
    function StealthDistribution(address _addressTokenUsedAsReward) {
        creator = msg.sender;
        addressOfTokenUsedAsReward = _addressTokenUsedAsReward;
        tokenReward = token(addressOfTokenUsedAsReward);
        
        //prepare sending tokens
        newFunder(0xE99E5E8fD0D1A5f3b7880f474f029C6B43F78c5d,10000000000000000000); //10 tokens
        newFunder(0x6772c7295920aA00A7f99243593eED1A04efa177,20000000000000000000); //20 tokens
        newFunder(0xF84ADa2e8db98714F32FbB62Ef1185Cb83Ea7bb4,30000000000000000000); //30 tokens
        newFunder(0x624870e1683DDDa37cbE5887F968BB510a6d0B3b,40000000000000000000); //40 tokens
    }
      
    function finishedCrowdsale() isCreator {
        crowdsaleIsActive = false;
    }
    
    // distribution of token after crowdsale
     function distributeToken() isCreator{
          require(crowdsaleIsActive);
          for(uint i=0;i<funder.length;i++)
          {
            Funder investor = funder[i];
            tokenReward.transfer(investor.addr, investor.noOfToken);
          }
       //   distributed = true;
     }
     
     //add Funder to struct of array
      function newFunder(address _funderAddress, uint _noOfToken) internal  {
        Funder memory newFunder;
        newFunder.addr = _funderAddress;
        newFunder.noOfToken  = _noOfToken;
        funder.push(newFunder)-1;
      }
}