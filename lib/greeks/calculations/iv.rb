module Math  
  module GreekCalculations
    def iv(opts)
      opts.requires_fields(:stock_price, :option_strike, :option_expires_pct_year, :federal_reserve_interest_rate_f, :stock_dividend_rate_f, :option_type, :option_price)
      
      iv_calc(
        opts[:stock_price], 
        opts[:option_strike], 
        opts[:option_expires_pct_year], 
        opts[:federal_reserve_interest_rate_f], 
        opts[:stock_dividend_rate_f], 
        opts[:option_type], 
        opts[:option_price]
      )
    end
    
    
    def iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
      Math.log(stock_price / option_strike) + (federal_reserve_interest_rate_f - stock_dividend_rate_f) * option_expires_pct_year
    end
    
    
    def iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f)
      stock_price * Math.exp(option_expires_pct_year * -stock_dividend_rate_f)
    end
    

    def iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)
    	var_d1 = (var_du + volatility_guess * volatility_guess * option_expires_pct_year / 2) / (volatility_guess * Math::sqrt(option_expires_pct_year))
    	var_nd = Math.exp(-var_d1 * var_d1 / 2) / Math::sqrt(2 * Math::PI)
    	return var_price_vs_rate_vs_expires * Math::sqrt(option_expires_pct_year) * var_nd
    end


    def iv_option_price(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, var_du, var_price_vs_rate_vs_expires)
    	var_x1 = option_strike * Math.exp(-volatility_guess * option_expires_pct_year)
    	var_d1 = (var_du + volatility_guess * volatility_guess * option_expires_pct_year / 2) / (volatility_guess * Math::sqrt(option_expires_pct_year))
    	var_d2 = var_d1 - volatility_guess * Math::sqrt(option_expires_pct_year)
    	if (option_type === :call)
    		return var_price_vs_rate_vs_expires * normal_distribution(var_d1) - var_x1 * normal_distribution(var_d2)
    	else
    		return var_x1 * normal_distribution(-var_d2) - var_price_vs_rate_vs_expires * normal_distribution(-var_d1)
      end
    end
    
    
    def iv_volatility_guess0(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
      Math.sqrt(
      (Math.log(stock_price / option_strike) + (federal_reserve_interest_rate_f - stock_dividend_rate_f) * option_expires_pct_year).abs * 2 / option_expires_pct_year)
    end
    
    
    # lastPrice, strike, exptime, irate, yield, 0, oprice
    def iv_calc(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, option_price)
      var_du = iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)

      var_price_vs_rate_vs_expires = iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f)

    	price_limit = [0.005, 0.01 * option_price].min
      
    	var_volatility_guess = iv_volatility_guess0(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
      var_volatility_guess = 0.1 if var_volatility_guess <= 0

    	var_option_price = iv_option_price(stock_price, option_strike, option_expires_pct_year, var_volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, var_du, var_price_vs_rate_vs_expires)

      return var_volatility_guess if ((option_price - var_option_price).abs < price_limit)

    	var_vega = iv_vega(stock_price, option_strike, option_expires_pct_year, var_volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)

    	var_volatility_guess1 = var_volatility_guess - (var_option_price - option_price) / var_vega

    	var_step = 1
      max_steps = 13
    	while ((var_volatility_guess - var_volatility_guess1).abs > 0.0001 && var_step < max_steps)
    		var_volatility_guess = var_volatility_guess1
    		var_option_price = iv_option_price(stock_price, option_strike, option_expires_pct_year, var_volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, var_du, var_price_vs_rate_vs_expires)

    		return var_volatility_guess if ((option_price - var_option_price).abs < price_limit)

    		var_vega = iv_vega(stock_price, option_strike, option_expires_pct_year, var_volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)

    		var_volatility_guess1 = var_volatility_guess - (var_option_price - option_price) / var_vega
    		return var_volatility_guess1 if (var_volatility_guess1 < 0)

    		var_step += 1
      end

    	return var_volatility_guess1 if (var_step < max_steps)

    	var_option_price = iv_option_price(stock_price, option_strike, option_expires_pct_year, var_volatility_guess1, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, var_du, var_price_vs_rate_vs_expires)

    	if ((option_price - var_option_price).abs < price_limit)
    		return var_volatility_guess1
    	else
    		return nil
      end
    end
    
  end
end
