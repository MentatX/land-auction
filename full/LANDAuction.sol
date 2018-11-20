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
    * @param _fromToken - IERC20 token
    * @param _toToken - IERC20 token 
    * @param _fromAmount - uint256 amount to be converted
    * @param _minReturn - uint256 mininum amount to be returned
    * @return uin256 of the amount after convertion
    */
    function convert(
        IERC20 _fromToken,
        IERC20 _toToken,
        uint256 _fromAmount,
        uint256 _minReturn
        ) external payable returns (uint256 amount);

    /**
    * @dev Get exchange rate and slippage rate. 
    * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
    * @param _fromToken - IERC20 token
    * @param _toToken - IERC20 token 
    * @param _fromAmount - uint256 amount to be converted
    * @return uint256 of the expected rate
    * @return uint256 of the slippage rate
    */
    function getExpectedRate(IERC20 _fromToken, IERC20 _toToken, uint256 _fromAmount) 
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
    enum Status { created, started, finished }

    Status public status;
    uint256 public gasPriceLimit;
    uint256 public landsLimitPerBid;
    ERC20 public manaToken;
    LANDRegistry public landRegistry;
    ITokenConverter public dex;
    mapping (address => bool) public tokensAllowed;

    uint256 internal initialPrice;
    uint256 internal endPrice;
    uint256 internal startedTime;
    uint256 internal duration;

    event AuctionCreated(
      address indexed _caller,
      uint256 _initialPrice,
      uint256 _endPrice,
      uint256 _duration
    );

    event AuctionStarted(
      address indexed _caller,
      uint256 _time
    );

    event BidSuccessful(
      address indexed _beneficiary,
      address indexed _token,
      uint256 _price,
      uint256 _totalPrice,
      int[] _xs,
      int[] _ys
    );

    event AuctionEnded(
      address indexed _caller,
      uint256 _price,
      uint256 _time
    );

    event MANABurned(
      address indexed _caller,
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
      address indexed _address
    );

    event TokenDisabled(
      address indexed _caller,
      address indexed _address
    );
}

// File: contracts/auction/LANDAuction.sol

contract LANDAuction is Ownable, LANDAuctionStorage {
    using SafeMath for uint256;
    using Address for address;

    /**
    * @dev Constructor of the contract
    * @param _initialPrice - uint256 initial LAND price
    * @param _endPrice - uint256 end LAND price
    * @param _duration - uint256 duration of the auction in seconds
    * @param _manaToken - address of the MANA token
    * @param _landRegistry - address of the LANDRegistry
    * @param _dex - address of the Dex to convert ERC20 tokens allowed to MANA
    * @param _allowedTokens - array of ERC20 addresses allowed to bid
    */
    constructor(
        uint256 _initialPrice, 
        uint256 _endPrice, 
        uint256 _duration, 
        ERC20 _manaToken, 
        LANDRegistry _landRegistry,
        address _dex,
        address[] _allowedTokens
    ) public {
        Ownable.initialize(msg.sender);

        require(
            address(_landRegistry).isContract(),
            "The LANDRegistry token address must be a deployed contract"
        );
        landRegistry = _landRegistry;

        if (_dex != address(0)) {
            setDex(_dex);
        }

        allowToken(address(_manaToken));
        manaToken = _manaToken;

        for (uint i = 0; i < _allowedTokens.length; i++) {
            address allowedToken = _allowedTokens[i];            
            allowToken(allowedToken);
        }


        require(_initialPrice > _endPrice, "The start price should be greater than end price");
        require(_duration > 24 * 60 * 60, "The duration should be greater than 1 day");

        duration = _duration;
        initialPrice = _initialPrice;
        endPrice = _endPrice;

        require(
            endPrice == _getPrice(duration),
            "The end price defined should be achieved when auction ends"
        );

        status = Status.created;      

        emit AuctionCreated(
            msg.sender,
            initialPrice, 
            endPrice,
            duration
        );
    }

    /**
    * @dev Start the auction
    * @param _landsLimitPerBid - uint256 LANDs limit for a single bid
    * @param _gasPriceLimit - uint256 gas price limit for a single bid
    */
    function startAuction(
        uint256 _landsLimitPerBid,
        uint256 _gasPriceLimit
    ) 
    external onlyOwner 
    {
        require(status == Status.created, "The auction was started");

        setLandsLimitPerBid(_landsLimitPerBid);
        setGasPriceLimit(_gasPriceLimit);

        startedTime = block.timestamp;
        status = Status.started;

        emit AuctionStarted(msg.sender, startedTime);
    }

    /**
    * @dev Burn the MANA earned by the auction
    */
    function burnFunds() external {
        require(
            status == Status.finished,
            "Burn should be performed when the auction is finished"
        );
        uint256 balance = manaToken.balanceOf(address(this));
        require(
            balance > 0,
            "No MANA to burn"
        );
        manaToken.burn(balance);

        emit MANABurned(msg.sender, balance);
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
        require(status == Status.started, "The auction was not started");
        require(block.timestamp - startedTime <= duration, "The auction has finished");
        require(tx.gasprice <= gasPriceLimit, "Gas price limit exceeded");
        require(_beneficiary != address(0), "The beneficiary could not be 0 address");
        require(_xs.length > 0, "You should bid to at least one LAND");
        require(_xs.length <= landsLimitPerBid, "LAND limit exceeded");
        require(_xs.length == _ys.length, "X values length should be equal to Y values length");
        require(tokensAllowed[address(_fromToken)], "token not accepted");

        uint256 currentPrice = getCurrentPrice();
        uint256 totalPrice = _xs.length.mul(currentPrice);

        if (address(_fromToken) != address(manaToken)) {
            require(
                address(dex).isContract(), 
                "Pay with other token than MANA is not available"
            );
            // Convert _fromToken to MANA
            require(convertSafe(_fromToken, totalPrice), "Converting token to MANA failed");
        } else {
            // Transfer MANA to LANDAuction contract
            require(
                _fromToken.transferFrom(msg.sender, address(this), totalPrice),
                "Transfering the totalPrice to LANDAuction contract failed"
            );
        }

        // Assign LANDs to _beneficiary
        for (uint i = 0; i < _xs.length; i++) {
            int x = _xs[i];
            int y = _ys[i];
            require(
                -150 <= x && x <= 150 && -150 <= y && y <= 150,
                "The coordinates should be inside bounds -150 & 150"
            );
        }
        landRegistry.assignMultipleParcels(_xs, _ys, _beneficiary);


        emit BidSuccessful(
            _beneficiary,
            _fromToken,
            currentPrice,
            totalPrice,
            _xs,
            _ys
        );
    }

    /**
    * @dev Current LAND price. If the auction was not started returns the started price
    * @return uint256 current LAND price
    */
    function getCurrentPrice() public view returns (uint256) { 
        if (startedTime == 0) {
            return _getPrice(0);
        } else {
            uint256 timePassed = block.timestamp - startedTime;
            return _getPrice(timePassed);
        }
    }

    /**
    * @dev Finish auction 
    */
    function finishAuction() public onlyOwner {
        require(status != Status.finished, "The auction is finished");
        status = Status.finished;

        uint256 currentPrice = getCurrentPrice();
        emit AuctionEnded(msg.sender, currentPrice, block.timestamp);
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
    */
    function allowToken(address _address) public onlyOwner {
        require(
            _address.isContract(),
            "Tokens allowed should be a deployed ERC20 contract"
        );
        require(!tokensAllowed[_address], "The ERC20 token is already allowed");
        tokensAllowed[_address] = true;
        emit TokenAllowed(msg.sender, _address);
    }

    /**
    * @dev Disable ERC20 to to be used for bidding
    * @param _address - address of the ERC20 Token
    */
    function disableToken(address _address) public onlyOwner {
        require(tokensAllowed[_address], "The ERC20 token is already disabled");
        tokensAllowed[_address] = false;
        emit TokenDisabled(msg.sender, _address);
    }

    /**
    * @dev Calculate LAND price based on time
    * It is a linear function y = ax - b. But The slope should be negative.
    * Based on two points (initialPrice; startedTime = 0) and (endPrice; endTime = duration)
    * slope = (endPrice - startedPrice) / (duration - startedTime)
    * As Solidity does not support negative number we use it as: y = b - ax
    * It should return endPrice if _time < duration
    * @param _time - uint256 time passed before reach duration
    * @return uint256 price for the given time
    */
    function _getPrice(uint256 _time) internal view returns (uint256) {
        if (_time >= duration) {
            return endPrice;
        }
        return  initialPrice.sub(initialPrice.sub(endPrice).mul(_time).div(duration));
    }

    /**
    * @dev Convert allowed token to MANA and transfer the change in MANA to the sender
    * Note that we will use the slippageRate cause it has a 3% buffer
    * @param _fromToken - ERC20 token to be converted
    * @param _totalPrice - uint256 of the total amount in MANA
    * @return bool to confirm the convertion was successfully
    */
    function convertSafe(ERC20 _fromToken, uint256 _totalPrice) internal returns (bool) {
        uint256 prevBalance = manaToken.balanceOf(address(this));
        uint256 tokenRate;
        (, tokenRate) = dex.getExpectedRate(_fromToken, manaToken, _totalPrice);
        uint256 totalPriceInToken = _totalPrice.mul(tokenRate).div(10 ** 18);

        require(
            _fromToken.transferFrom(msg.sender, address(this), totalPriceInToken),
            "Transfering the totalPrice in token to LANDAuction contract failed"
        );
        
        require(_fromToken.approve(address(dex), totalPriceInToken), "Error approve");

        uint256 bought = dex.convert(
                _fromToken,
                manaToken,
                totalPriceInToken,
                1
            );
        require(
            manaToken.balanceOf(address(this)).sub(prevBalance) >= bought,
            "Bought amount incorrect"
        );

        if (bought > _totalPrice) {
            // return mana to sender
            uint256 change = bought.sub(_totalPrice);
            require(
                manaToken.transfer(msg.sender, change),
                "Transfering the change to sender failed"
            );
        }

        require(_fromToken.approve(address(dex), 0), "Error remove approve");
        return true;
    }
}
