pragma solidity ^0.4.24;

import "../dex/ITokenConverter.sol";


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

    enum Status { created, started, finished }

    struct tokenAllowed {
        uint256 decimals;
        bool shouldKeepToken;
        bool isAllowed;
    }

    Status public status;
    uint256 public gasPriceLimit;
    uint256 public landsLimitPerBid;
    ERC20 public manaToken;
    LANDRegistry public landRegistry;
    ITokenConverter public dex;
    mapping (address => tokenAllowed) public tokensAllowed;

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
      uint256 _time,
      uint256 _price
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
      address indexed _address,
      uint256 _decimals,
      bool _shouldKeepToken
    );

    event TokenDisabled(
      address indexed _caller,
      address indexed _address
    );
}