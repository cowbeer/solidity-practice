// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Constant Sum Automated Market Maker
contract CSAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    uint public reserve0;
    uint public reserve1;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _res0, uint _res1) private {
        reserve0 = _res0;
        reserve1 = _res1;
    }

    function swap(address _tokenIn, uint _amountIn) external returns(uint amountOut){
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "invalid token");
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut) = isToken0 ? (token0, token1, reserve0, reserve1) : (token1, token0, reserve1, reserve0);

        // transfer token in
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountIn = tokenIn.balanceOf(address(this)) - resIn;

        // calculate amount out (including fees)
        // 0.3% fee
        amountOut = (amountIn * 997) / 1000;

        // update reserve0 and reserve1
        (uint res0, uint res1) = isToken0 ? (resIn + amountIn, resOut - amountOut) : (resOut - amountOut, resIn + _amountIn);
        _update(res0, res1);

        // transfer token out
        tokenOut.transfer(msg.sender, amountOut);

    }

    function addLiquidity(uint _amount0, uint _amount1) external returns(uint shares){
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));
        uint d0 = bal0 - reserve0;
        uint d1 = bal1 - reserve1;
        /*
            a = amount in
            L = total liquidity
            s = shares to mint
            T = total supply
            (L + a) / L = (T + s) / T

            s = aT / L
        */
        if (totalSupply == 0) {
            shares = d0 + d1;
        }
        else {
            shares = (d0 + d1) * totalSupply / (reserve0 + reserve1);
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);
        _update(bal0, bal1);
    }

    function removeLiquidity(uint _shares) external returns(uint d0, uint d1) {
        /*
            a = amount out
            L = total liquidity
            s = shares
            T = total supply
            a / L = s / T

            a = Ls / T = (reserve0 + reserve1) * s / T
        */
        d0 = (reserve0 * _shares) / totalSupply;
        d1 = (reserve1 * _shares) / totalSupply;
        _burn(msg.sender, _shares);
        _update(reserve0 - d0, reserve1 - d1);
        if (d0 > 0) {
            token0.transfer(msg.sender, d0);
        }
        if (d1 > 0) {
            token1.transfer(msg.sender, d1);
        }
    }
}
