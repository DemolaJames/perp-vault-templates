//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IWETH} from "../interfaces/IWETH.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";

/**
 * @dev ZeroX Exchange contract interface.
 */
contract MockZeroXV4 {
  using SafeMath for uint256;

  // solhint-disable max-line-length
  /// @dev Canonical order structure
  struct LimitOrder {
    address makerToken; // The ERC20 token the maker is selling and the maker is selling to the taker.
    address takerToken; // The ERC20 token the taker is selling and the taker is selling to the maker.
    uint128 makerAmount; // The amount of makerToken being sold by the maker.
    uint128 takerAmount; // The amount of takerToken being sold by the taker.
    uint128 takerTokenFeeAmount; // Amount of takerToken paid by the taker to the feeRecipient.
    address maker; // The address of the maker, and signer, of this order.
    address taker; // Allowed taker address. Set to zero to allow any taker.
    address sender; // Allowed address to call fillLimitOrder() (msg.sender). This is the same as taker, expect when using meta-transactions. Set to zero to allow any caller.
    address feeRecipient; // Recipient of maker token or taker token fees (if non-zero).
    bytes32 pool; // The staking pool to attribute the 0x protocol fee from this order. Set to zero to attribute to the default pool, not owned by anyone.
    uint64 expiry; // The Unix timestamp in seconds when this order expires.
    uint256 salt; // Arbitrary number to facilitate uniqueness of the order's hash.
  }

  /// @dev An RFQ limit order.
  struct RfqOrder {
    address makerToken;
    address takerToken;
    uint128 makerAmount;
    uint128 takerAmount;
    address maker;
    address taker;
    address txOrigin;
    bytes32 pool;
    uint64 expiry;
    uint256 salt;
  }

  struct Signature {
    uint8 signatureType; // Either 2 (EIP712) or 3 (EthSign)
    uint8 v; // Signature data.
    bytes32 r; // Signature data.
    bytes32 s; // Signature data.
  }

  /// @dev Executes multiple calls of fillLimitOrder.
  function fillLimitOrder(
    LimitOrder calldata order,
    Signature calldata, /*signature*/
    uint128 takerTokenFillAmount
  ) external payable returns (uint128 _takerTokenFillAmount, uint128 makerTokenFillAmount) {
    IERC20(order.takerToken).transferFrom(msg.sender, order.maker, takerTokenFillAmount);
    return (0, 0);
  }

  function fillRfqOrder(
    RfqOrder calldata order, // The order
    Signature calldata, /*signature*/ // The signature
    uint128 takerTokenFillAmount // How much taker token to fill the order with
  ) external payable {
    IERC20(order.takerToken).transferFrom(msg.sender, order.maker, takerTokenFillAmount);
  }
}
