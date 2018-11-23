pragma solidity ^0.4.24;

// File: zos-lib/contracts/Initializable.sol

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool wasInitializing = initializing;
    initializing = true;
    initialized = true;

    _;

    initializing = wasInitializing;
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    uint256 cs;
    assembly { cs := extcodesize(address) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: openzeppelin-eth/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable is Initializable {
  address private _owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function initialize(address sender) public initializer {
    _owner = sender;
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(_owner);
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }

  uint256[50] private ______gap;
}

// File: openzeppelin-eth/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

// File: openzeppelin-eth/contracts/utils/Address.sol

/**
 * Utility library of inline functions on addresses
 */
library Address {

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param account address of the account to check
   * @return whether the target address is a contract
   */
  function isContract(address account) internal view returns (bool) {
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(account) }
    return size > 0;
  }
}

// File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: contracts/dex/ITokenConverter.sol

contract ITokenConverter {    
    using SafeMath for uint256;

    /**
    * @dev Makes a simple ERC20 -> ERC20 token trade
    * @param _srcToken - IERC20 token
    * @param _destToken - IERC20 token 
    * @param _srcAmount - uint256 amount to be converted
    * @param _destAmount - uint256 amount to get after convertion
    * @return uint256 for the change. 0 if there is no change
    */
    function convert(
        IERC20 _srcToken,
        IERC20 _destToken,
        uint256 _srcAmount,
        uint256 _destAmount
        ) external payable returns (uint256);

    /**
    * @dev Get exchange rate and slippage rate. 
    * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
    * @param _srcToken - IERC20 token
    * @param _destToken - IERC20 token 
    * @param _srcAmount - uint256 amount to be converted
    * @return uint256 of the expected rate
    * @return uint256 of the slippage rate
    */
    function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
        public view returns(uint256 expectedRate, uint256 slippageRate);
}

// File: contracts/auction/LANDAuctionStorage.sol

/**
* @title ERC20 Interface with burn
* @dev IERC20 imported in ItokenConverter.sol
*/
contract ERC20 is IERC20 {
    function burn(uint256 _value) public;
}


/**
* @title Interface for contracts conforming to ERC-721
*/
contract LANDRegistry {
    function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
}


contract LANDAuctionStorage {
    uint256 constant public PERCENTAGE_OF_TOKEN_TO_KEEP = 5;
    uint256 constant public MAX_DECIMALS = 18;

    enum Status { created, finished }

    struct Func {
        uint256 slope;
        uint256 base;
        uint256 limit;
    }
    struct Token {
        uint256 decimals;
        bool shouldKeepToken;
        bool isAllowed;
    }

    uint256 public convertionFee = 105;
    uint256 public totalBids = 0;
    Status public status;
    uint256 public gasPriceLimit;
    uint256 public landsLimitPerBid;
    ERC20 public manaToken;
    ERC20 public daiToken;
    LANDRegistry public landRegistry;
    address public daiCharity;
    address public tokenKiller;
    ITokenConverter public dex;
    mapping (address => Token) public tokensAllowed;
    Func[] internal curves;

    uint256 internal initialPrice;
    uint256 internal endPrice;
    uint256 internal startTime;
    uint256 internal duration;

    event AuctionCreated(
      address indexed _caller,
      uint256 _startTime,
      uint256 _duration,
      uint256 _initialPrice,
      uint256 _endPrice
    );

    event BidConvertion(
      uint256 _bidId,
      address indexed _token,
      uint256 _totalPriceInMana,
      uint256 _totalPriceInToken,
      uint256 _tokensKept
    );

    event BidSuccessful(
      uint256 _bidId,
      address indexed _beneficiary,
      address indexed _token,
      uint256 _price,
      uint256 _totalPrice,
      int[] _xs,
      int[] _ys
    );

    event AuctionEnded(
      address indexed _caller,
      uint256 _time,
      uint256 _price
    );

    event TokenBurned(
      uint256 _bidId,
      address indexed _token,
      uint256 _total
    );

    event LandsLimitPerBidChanged(
      address indexed _caller,
      uint256 _oldLandsLimitPerBid, 
      uint256 _landsLimitPerBid
    );

    event GasPriceLimitChanged(
      address indexed _caller,
      uint256 _oldGasPriceLimit,
      uint256 _gasPriceLimit
    );

    event DexChanged(
      address indexed _caller,
      address indexed _oldDex,
      address indexed _dex
    );

    event TokenAllowed(
      address indexed _caller,
      address indexed _address,
      uint256 _decimals,
      bool _shouldKeepToken
    );

    event TokenDisabled(
      address indexed _caller,
      address indexed _address
    );

    event ConvertionFeeChanged(
      address indexed _caller,
      uint256 _oldConvertionFee,
      uint256 _convertionFee
    );
}

// File: contracts/auction/LANDAuction.sol

contract LANDAuction is Ownable, LANDAuctionStorage {
    using SafeMath for uint256;
    using Address for address;

    /**
    * @dev Constructor of the contract.
    * Note that the last value of _xPoints will be the total duration and
    * the first value of _yPoints will be the initial price and the last value will be the endPrice
    * @param _xPoints - uint256[] of seconds
    * @param _yPoints - uint256[] of prices
    * @param _startTime - uint256 timestamp in seconds when the auction will start
    * @param _landsLimitPerBid - uint256 LANDs limit for a single bid
    * @param _gasPriceLimit - uint256 gas price limit for a single bid
    * @param _manaToken - address of the MANA token
    * @param _landRegistry - address of the LANDRegistry
    * @param _dex - address of the Dex to convert ERC20 tokens allowed to MANA
    */
    constructor(
        uint256[] _xPoints, 
        uint256[] _yPoints, 
        uint256 _startTime,
        uint256 _landsLimitPerBid,
        uint256 _gasPriceLimit,
        ERC20 _manaToken, 
        ERC20 _daiToken,
        LANDRegistry _landRegistry,
        address _dex,
        address _daiCharity,
        address _tokenKiller
    ) public {
        // Initialize owneable
        Ownable.initialize(msg.sender);

        // Schedule auction
        require(_startTime > block.timestamp, "Started time should be after now");
        startTime = _startTime;

        // Set LANDRegistry
        require(
            address(_landRegistry).isContract(),
            "The LANDRegistry token address must be a deployed contract"
        );
        landRegistry = _landRegistry;

        require(
            address(_daiCharity).isContract(),
            "The DAI Charity token address must be a deployed contract"
        );
        daiCharity = _daiCharity;

        require(
            address(_tokenKiller).isContract(),
            "The Token Killer must be a deployed contract"
        );
        tokenKiller = _tokenKiller;


        setDex(_dex);

        // Set MANAToken
        allowToken(address(_manaToken), 18, true);
        manaToken = _manaToken;

        // Allow DAI and keep tokens
        allowToken(address(_daiToken), 18, true);
        daiToken = _daiToken;

        // Set total duration of the auction
        duration = _xPoints[_xPoints.length - 1];
        require(duration > 24 * 60 * 60, "The duration should be greater than 1 day");

        // Set Curve
        _setCurve(_xPoints, _yPoints);

        // Set limits
        setLandsLimitPerBid(_landsLimitPerBid);
        setGasPriceLimit(_gasPriceLimit);
        
        // Initialize status
        status = Status.created;      

        emit AuctionCreated(
            msg.sender,
            _startTime,
            duration,
            initialPrice, 
            endPrice
        );
    }

    /**
    * @dev Make a bid for LANDs
    * @param _xs - uint256[] x values for the LANDs to bid
    * @param _ys - uint256[] y values for the LANDs to bid
    * @param _beneficiary - address beneficiary for the LANDs to bid
    * @param _fromToken - token used to bid
    */
    function bid(
        int[] _xs, 
        int[] _ys, 
        address _beneficiary, 
        ERC20 _fromToken
    ) external 
    {
        _validateBidParameters(
            _xs, 
            _ys, 
            _beneficiary, 
            _fromToken
        );
        
        uint256 bidId = _getBidId();
        uint256 currentPrice = getCurrentPrice();
        uint256 totalPrice = _xs.length.mul(currentPrice);
        
        if (address(_fromToken) != address(manaToken)) {
            require(
                address(dex).isContract(), 
                "Pay with other token than MANA is not available"
            );
            // Convert _fromToken to MANA
            totalPrice = _convertSafe(bidId, _fromToken, totalPrice);
        } else {
            // Transfer MANA to LANDAuction contract
            require(
                _fromToken.transferFrom(msg.sender, address(this), totalPrice),
                "Transfering the totalPrice to LANDAuction contract failed"
            );
        }

        // Burn Transferred funds
        _burnFunds(bidId, _fromToken);

        // Assign LANDs to _beneficiary
        for (uint i = 0; i < _xs.length; i++) {
            require(
                -150 <= _xs[i] && _xs[i] <= 150 && -150 <= _ys[i] && _ys[i] <= 150,
                "The coordinates should be inside bounds -150 & 150"
            );
        }
        landRegistry.assignMultipleParcels(_xs, _ys, _beneficiary);

        emit BidSuccessful(
            bidId,
            _beneficiary,
            _fromToken,
            currentPrice,
            totalPrice,
            _xs,
            _ys
        );  

        // Increment bids count
        _incrementBids();
    }

    /**
    * @dev Allow many ERC20 tokens to to be used for bidding
    * @param _address - array of addresses of the ERC20 Token
    * @param _decimals - array of uint256 of the number of decimals
    * @param _shouldKeepToken - array of boolean whether we should keep the token or not
    */
    function allowManyTokens(
        address[] _address, 
        uint256[] _decimals, 
        bool[] _shouldKeepToken
    ) external onlyOwner
    {
        require(
            _address.length == _decimals.length && _decimals.length == _shouldKeepToken.length,
            "The length of _addresses, decimals and _shouldKeepToken should be the same"
        );

        for (uint i = 0; i < _address.length; i++) {
            allowToken(_address[i], _decimals[i], _shouldKeepToken[i]);
        }
    }

    /**
    * @dev Set convertion fee rate
    * @param _fee - uint256 for the new convertion rate
    */
    function setConvertionFee(uint256 _fee) external onlyOwner {
        require(_fee < 200 && _fee >= 100, "Convertion fee should be >= 100 and < 200");
        emit ConvertionFeeChanged(msg.sender, convertionFee, _fee);
        convertionFee = _fee;
    }

    /**
    * @dev Current LAND price. 
    * Note that if the auction was not started returns the initial price and when
    * the auction is finished return the endPrice
    * @return uint256 current LAND price
    */
    function getCurrentPrice() public view returns (uint256) { 
        // If the auction has not started returns initialPrice
        if (startTime == 0 || startTime >= block.timestamp) {
            return initialPrice;
        }

        // If the auction has finished returns endPrice
        uint256 timePassed = block.timestamp - startTime;
        if (timePassed >= duration) {
            return endPrice;
        }

        return _getPrice(timePassed);
    }

    /**
    * @dev Finish auction 
    */
    function finishAuction() public onlyOwner {
        require(status != Status.finished, "The auction is finished");
        status = Status.finished;

        uint256 currentPrice = getCurrentPrice();
        emit AuctionEnded(msg.sender, block.timestamp, currentPrice);
    }

    /**
    * @dev Set LANDs limit for the auction
    * @param _landsLimitPerBid - uint256 LANDs limit for a single id
    */
    function setLandsLimitPerBid(uint256 _landsLimitPerBid) public onlyOwner {
        require(_landsLimitPerBid > 0, "The lands limit should be greater than 0");
        emit LandsLimitPerBidChanged(msg.sender, landsLimitPerBid, _landsLimitPerBid);
        landsLimitPerBid = _landsLimitPerBid;
    }

    /**
    * @dev Set gas price limit for the auction
    * @param _gasPriceLimit - uint256 gas price limit for a single bid
    */
    function setGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
        require(_gasPriceLimit > 0, "The gas price should be greater than 0");
        emit GasPriceLimitChanged(msg.sender, gasPriceLimit, _gasPriceLimit);
        gasPriceLimit = _gasPriceLimit;
    }

    /**
    * @dev Set dex to convert ERC20
    * @param _dex - address of the token converter
    */
    function setDex(address _dex) public onlyOwner {
        require(_dex != address(dex), "The dex is the current");
        if (_dex != address(0)) {
            require(_dex.isContract(), "The dex address must be a deployed contract");
        }
        emit DexChanged(msg.sender, dex, _dex);
        dex = ITokenConverter(_dex);
    }

    /**
    * @dev Allow ERC20 to to be used for bidding
    * @param _address - address of the ERC20 Token
    * @param _decimals - uint256 of the number of decimals
    * @param _shouldKeepToken - boolean whether we should keep the token or not
    */
    function allowToken(
        address _address, 
        uint256 _decimals, 
        bool _shouldKeepToken) 
    public onlyOwner 
    {
        require(
            _address.isContract(),
            "Tokens allowed should be a deployed ERC20 contract"
        );
        require(
            _decimals > 0 && _decimals <= MAX_DECIMALS,
            "Decimals should be greather than 0 and less or equal to 18"
        );
        require(!tokensAllowed[_address].isAllowed, "The ERC20 token is already allowed");

        tokensAllowed[_address] = Token({
            decimals: _decimals,
            shouldKeepToken: _shouldKeepToken,
            isAllowed: true
        });

        emit TokenAllowed(
            msg.sender, 
            _address, 
            _decimals, 
            _shouldKeepToken
        );
    }

    /**
    * @dev Disable ERC20 to to be used for bidding
    * @param _address - address of the ERC20 Token
    */
    function disableToken(address _address) public onlyOwner {
        require(
            tokensAllowed[_address].isAllowed,
            "The ERC20 token is already disabled"
        );
        delete tokensAllowed[_address];
        emit TokenDisabled(msg.sender, _address);
    }

    /**
    * @dev Get exchange rate
    * @param _srcToken - IERC20 token
    * @param _destToken - IERC20 token 
    * @param _srcAmount - uint256 amount to be converted
    * @return uint256 of the rate
    */
    function getRate(
        IERC20 _srcToken, 
        IERC20 _destToken, 
        uint256 _srcAmount
    ) public view returns (uint256 rate) 
    {
        (, rate) = dex.getExpectedRate(_srcToken, _destToken, _srcAmount);
    }

    /**
    * @dev Convert allowed token to MANA and transfer the change in the original token
    * Note that we will use the slippageRate cause it has a 3% buffer and a deposit of 5% to cover
    * the convertion fee.
    * @param _bidId - uint256 of the bid Id
    * @param _fromToken - ERC20 token to be converted
    * @param _totalPrice - uint256 of the total amount in MANA
    * @return uint256 of the total amount of MANA
    */
    function _convertSafe(
        uint256 _bidId,
        ERC20 _fromToken,
        uint256 _totalPrice
    ) internal returns (uint256 totalPrice)
    {
        totalPrice = _totalPrice;
        Token memory fromToken = tokensAllowed[address(_fromToken)];

        uint totalPriceWithDeposit = totalPrice.mul(convertionFee).div(100);

        // Get rate
        uint256 tokenRate = getRate(manaToken, _fromToken, totalPriceWithDeposit);

        // Check if contract should keep a percentage of _fromToken
        uint256 tokensToKeep = 0;
        if (fromToken.shouldKeepToken) {
            (tokensToKeep, totalPrice) = _calculateTokensToKeep(totalPrice, tokenRate);
        }

        // Calculate the amount of _fromToken needed
        uint256 totalPriceInToken = totalPriceWithDeposit.mul(tokenRate).div(10 ** 18);

        // Normalize to _fromToken decimals
        if (MAX_DECIMALS > fromToken.decimals) {
            (tokensToKeep, totalPriceInToken) = _normalizeDecimals(
                fromToken.decimals, 
                tokensToKeep, 
                totalPriceInToken
            );
         }
        

        // Transfer _fromToken amount from sender to the contract
        require(
            _fromToken.transferFrom(msg.sender, address(this), totalPriceInToken),
            "Transfering the totalPrice in token to LANDAuction contract failed"
        );
        
        // Calculate the total tokens to convert
        uint256 totalTokensToConvert = totalPriceInToken.sub(tokensToKeep);

        // Approve amount of _fromToken owned by contract to be used by dex contract
        require(_fromToken.approve(address(dex), totalTokensToConvert), "Error approve");

        // Convert _fromToken to MANA
        uint256 change = dex.convert(
                _fromToken,
                manaToken,
                totalTokensToConvert,
                totalPrice
        );

       // Return change in _fromToken to sender
        if (change > 0) {
            // Return the change of src token
            require(
                _fromToken.transfer(msg.sender, change),
                "Transfering the change to sender failed"
            );
        }

        // Remove approval of _fromToken owned by contract to be used by dex contract
        require(_fromToken.approve(address(dex), 0), "Error remove approval");

        emit BidConvertion(
            _bidId,
            address(_fromToken),
            totalPrice,
            totalPriceInToken.sub(change),
            tokensToKeep
        );
    }

    /** 
    * @dev Calculate the amount of tokens to keep and the total price in MANA
    * Note that PERCENTAGE_OF_TOKEN_TO_KEEP will be always less than 100
    * @param _totalPrice - uint256 price to calculate percentage to keep
    * @param _tokenRate - rate to calculate the amount of tokens
    * @return tokensToKeep - uint256 of the amount of tokens to keep
    * @return totalPrice - uint256 of the new total price in MANA
    */
    function _calculateTokensToKeep(uint256 _totalPrice, uint256 _tokenRate) 
    internal pure returns (uint256 tokensToKeep, uint256 totalPrice) 
    {
        tokensToKeep = _totalPrice.mul(_tokenRate)
            .div(10 ** 18)
            .mul(PERCENTAGE_OF_TOKEN_TO_KEEP)
            .div(100);
            
        totalPrice = _totalPrice.mul(100 - PERCENTAGE_OF_TOKEN_TO_KEEP).div(100);
    }

    /** 
    * @dev Normalize to _fromToken decimals
    * @param _decimals - uint256 of _fromToken decimals
    * @param _tokensToKeep - uint256 of the amount of tokens to keep
    * @param _totalPriceInToken - uint256 of the amount of _fromToken
    * @return tokensToKeep - uint256 of the amount of tokens to keep in _fromToken decimals
    * @return totalPriceInToken - address beneficiary for the LANDs to bid in _fromToken decimals
    */
    function _normalizeDecimals(
        uint256 _decimals, 
        uint256 _tokensToKeep, 
        uint256 _totalPriceInToken
    ) 
    internal pure returns (uint256 tokensToKeep, uint256 totalPriceInToken) 
    {
        uint256 newDecimals = 10**MAX_DECIMALS.sub(_decimals);

        totalPriceInToken = _totalPriceInToken.div(newDecimals);
        tokensToKeep = _tokensToKeep.div(newDecimals);
    }

    /** 
    * @dev Validate bid function params
    * @param _xs - uint256[] x values for the LANDs to bid
    * @param _ys - uint256[] y values for the LANDs to bid
    * @param _beneficiary - address beneficiary for the LANDs to bid
    * @param _fromToken - token used to bid
    */
    function _validateBidParameters(
        int[] _xs, 
        int[] _ys, 
        address _beneficiary, 
        ERC20 _fromToken
    ) internal view 
    {
        require(startTime <= block.timestamp, "The auction has not started");
        require(
            status == Status.created && 
            block.timestamp.sub(startTime) <= duration, 
            "The auction has finished"
        );
        require(tx.gasprice <= gasPriceLimit, "Gas price limit exceeded");
        require(_beneficiary != address(0), "The beneficiary could not be 0 address");
        require(_xs.length > 0, "You should bid to at least one LAND");
        require(_xs.length <= landsLimitPerBid, "LAND limit exceeded");
        require(_xs.length == _ys.length, "X values length should be equal to Y values length");
        require(tokensAllowed[address(_fromToken)].isAllowed, "Token not allowed");
    }

    /**
    * @dev Burn the MANA and other tokens earned
    * @param _bidId - uint256 of the bid Id
    * @param _token - ERC20 token
    */
    function _burnFunds(uint256 _bidId, ERC20 _token) internal {
        if (_token != manaToken && tokensAllowed[address(_token)].shouldKeepToken) {
            // Burn no MANA token
            _burnToken(_bidId, _token);
        }

        // Burn MANA token
        _burnToken(_bidId, manaToken);       
    }

    /** 
    * @dev Create a combined function.
    * note that we will set N - 1 function combinations based on N points (x,y)
    * @param _xPoints - uint256[] of x values
    * @param _yPoints - uint256[] of y values
    */
    function _setCurve(uint256[] _xPoints, uint256[] _yPoints) internal {
        uint256 pointsLength = _xPoints.length;
        require(pointsLength == _yPoints.length, "Points should have the same length");
        for (uint i = 0; i < pointsLength - 1; i++) {
            uint256 x1 = _xPoints[i];
            uint256 x2 = _xPoints[i + 1];
            uint256 y1 = _yPoints[i];
            uint256 y2 = _yPoints[i + 1];
            require(x1 < x2, "X points should increase");
            require(y1 > y2, "Y points should decrease");
            (uint256 base, uint256 slope) = _getFunc(
                x1, 
                x2, 
                y1, 
                y2
            );
            curves.push(Func({
                base: base,
                slope: slope,
                limit: x2
            }));
        }

        initialPrice = _yPoints[0];
        endPrice = _yPoints[pointsLength - 1];
    }

    /**
    * @dev LAND price based on time
    * Note that will select the function to calculate based on the time
    * It should return endPrice if _time < duration
    * @param _time - uint256 time passed before reach duration
    * @return uint256 price for the given time
    */
    function _getPrice(uint256 _time) internal view returns (uint256) {
        for (uint i = 0; i < curves.length; i++) {
            Func memory func = curves[i];
            if (_time < func.limit) {
                return func.base.sub(func.slope.mul(_time));
            }
        }
        revert("Invalid time");
    }

    /**
    * @dev Calculate base and slope for the given points
    * It is a linear function y = ax - b. But The slope should be negative.
    * As we want to avoid negative numbers in favor of using uints we use it as: y = b - ax
    * Based on two points (x1; x2) and (y1; y2)
    * base = (x2 * y1) - (x1 * y2) / x2 - x1
    * slope = (y1 - y2) / (x2 - x1) to avoid negative maths
    * @param _x1 - uint256 x1 value
    * @param _x2 - uint256 x2 value
    * @param _y1 - uint256 y1 value
    * @param _y2 - uint256 y2 value
    * @return uint256 for the base
    * @return uint256 for the slope
    */
    function _getFunc(
        uint256 _x1,
        uint256 _x2,
        uint256 _y1, 
        uint256 _y2
    ) internal pure returns (uint256 base, uint256 slope) 
    {
        base = ((_x2.mul(_y1)).sub(_x1.mul(_y2))).div(_x2.sub(_x1));
        slope = (_y1.sub(_y2)).div(_x2.sub(_x1));
    }

    /** 
    * @dev Burn tokens. 
    * Note that if the token is the DAI token we will transfer the funds 
    * to the DAI charity contract.
    * For the rest of the tokens if not implement the burn method 
    * we will transfer the funds to a token killer address
    * @param _bidId - uint256 of the bid Id
    * @param _token - ERC20 token
    */
    function _burnToken(uint256 _bidId, ERC20 _token) private {
        uint256 balance = _token.balanceOf(address(this));

        // Check if balance is valid
        require(balance > 0, "Balance to burn should be > 0");

        if (_token == daiToken) {
            // Transfer to DAI charity if token to burn is DAI
            require(
                _token.transfer(daiCharity, balance),
                "Could not transfer tokens to DAI charity" 
            );
        } else {
            // Burn funds
            bool result = _safeBurn(_token, balance);

            if (!result) {
                // If token does not implement burn method suicide tokens
                require(
                    _token.transfer(tokenKiller, balance),
                    "Could not transfer tokens to the token killer contract" 
                );
            }
        }

        emit TokenBurned(_bidId, address(_token), balance);

        // Check if balance of the auction contract is empty
        balance = _token.balanceOf(address(this));
        require(balance == 0, "Burn token failed");
    }

    /** 
    * @dev Execute burn method. 
    * Note that if the contract does not implement it will return false
    * @param _token - ERC20 token
    * @param _amount - uint256 of the amount to burn
    * @return bool if burn has been successfull
    */
    function _safeBurn(ERC20 _token, uint256 _amount) private returns (bool success) {
        success = address(_token).call(abi.encodeWithSelector(
            _token.burn.selector,
            _amount
        ));        
    }

    /**
    * @dev Return bid id
    * @return uint256 of the bid id
    */
    function _getBidId() private view returns (uint256) {
        return totalBids;
    }

    /** 
    * @dev Increments bid id 
    */
    function _incrementBids() private {
        totalBids = totalBids.add(1);
    }
}
