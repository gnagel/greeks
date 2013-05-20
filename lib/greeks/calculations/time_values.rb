module Math
  module GreekCalculations
    
    def nil_or_gte0(value)
      value.nil? || value.to_f < 0 ? nil : value
    end


    # Intrinsic Value
    # The value that the option would pay if it were executed today. For example, if a stock is trading at $40,
    # a call on that stock with a strike price of $35 would have $5 of intrinsic value ($40-$35) if it were 
    # exercised today. However, the call should actually be worth more than $5 to account for the value of the 
    # chance of any further appreciation until expiration, and the difference between the price and the 
    # intrinsic value would be the time value.
    def premium_value(opts)
      opts.requires_fields(:option_type, :option_strike, :stock_price)
      
      case opts[:option_type]
      when :call
        return [opts[:stock_price] - opts[:option_strike], 0].max
      when :put
        return [opts[:option_strike] - opts[:stock_price], 0].max
      else
        raise ArgumentError, "Invalid option_type = #{opts[:option_type]}"
      end
    end


    # Time Value
    # The value of an option that captures the chance of further appreciation before expiration.
    # The value of an option can be broken down into intrinsic value, or the value of the option 
    # if it were exercised today, and time value, or the added value of the option over and above
    # the intrinsic value. For example, if a stock is trading at $40 and a call with a strike price
    # of $35 were trading for $7, the call would have a $5 intrinsic value ($40-$35) and a $2 time value ($7-$5). 
    # Time value will decay by expiration assuming the underlying security stays at the same price.
    def time_value(opts)
      opts.requires_fields(:option_price, :premium_value)

      return nil if opts[:option_price].nil?
      return nil if opts[:option_price] < 0
      
      nil_or_gte0(opts[:option_price] - opts[:premium_value])
    end


    # Annualized Premium
    # The annualized premium is the value of the option divided by the strike price. You can use annualized 
    # premium to develop an intuitive understanding of how much the market is "paying" for a dollar of risk. 
    # For example, if a stock is trading at $50 and you sell a $50 strike 6 month call for $4, you are getting
    # paid 8% in 6 months, or about 16% annualized, in exchange for being willing to buy at $50, the current price.
    def annualized_premium_value
      opts.requires_fields(:option_price, :option_strike, :option_expires_pct_year)

      return nil if opts[:option_price].nil?
      return nil if opts[:option_price] < 0

      nil_or_gte0(100 * Math.log(1 + opts[:option_price] / opts[:option_strike]) / opts[:option_expires_pct_year])
    end


    # Annualized Time Value
    # The time value of the option divided by the strike price, then annualized. You can use annualized 
    # time value to develop an intuitive understanding of how much value the option market is adding to
    # an in-the-money option beyond the intrinsic value. For example, if a stock is trading at $40 and a
    # six month call on that stock with a strike price of $35 has an intrinsic value of $5 and a total 
    # value of $7, the time value ($2) divided by the strike is ($2/$40) = 5%. Annualizing that time value 
    # to a one year horizon on a continuously compounded basis yields 9.76% (2 × ln(1 + 0.05)).
    def annualized_time_value
      opts.requires_fields(:option_strike, :option_expires_pct_year, :time_value)

      return nil if opts[:time_value].nil?
      
      nil_or_gte0(100 * Math.log(1.0 + opts[:time_value] / opts[:option_strike]) / opts[:option_expires_pct_year])
    end
    
    
    # Chance of Breakeven
    # The probability that a stock will be trading beyond the breakeven price as implied by the option price.
    # Chance of Breakeven can be used to get a sense for the valuation of the option by comparing the markets'
    # estimate of Chance of Breakeven to estimates derived from your own fundamental research.
    # If you believe the Chance of Breakeven is less than the probability that a stock will be beyond the
    # breakeven price at option expiration, then you believe the option is undervalued, and visa versa.
    def break_even(opts)
      opts.requires_fields(:option_type, :option_price, :option_strike, :option_expires_pct_year, :option_expires_pct_year_sqrt, :stock_price, :stock_dividend_rate_f, :federal_reserve_interest_rate_f, :iv)

      return nil if opts[:option_price].nil?
      return nil if opts[:option_price] < 0
      return nil if opts[:iv].nil?
      
      part1 = (opts[:federal_reserve_interest_rate_f] - opts[:stock_dividend_rate_f] - opts[:iv] * opts[:iv] / 2) * opts[:option_expires_pct_year]
      part2 = opts[:iv] * opts[:option_expires_pct_year_sqrt]
      
      case opts[:option_type]
      when :call
    		return normal_distribution((Math.log(opts[:stock_price] / (opts[:option_strike] + opts[:option_price])) + part1) / part2)
      when :put
  			return normal_distribution(-(Math.log(opts[:stock_price] / (opts[:option_strike] - opts[:option_price])) + part1) / part2)
      else
        raise ArgumentError, "Invalid option_type = #{opts[:option_type]}"
      end
    end
    
    
    #####
    # Misc calculations
    #####
    
    
    def misc_price_ratio_log_less_rates(opts)
      opts.requires_fields(:stock_price, :option_strike, :option_expires_pct_year, :federal_reserve_interest_rate_f, :stock_dividend_rate_f)
      
      Math.log(opts[:stock_price] / opts[:option_strike]) + (opts[:federal_reserve_interest_rate_f] - opts[:stock_dividend_rate_f]) * opts[:option_expires_pct_year]
    end
    

    def misc_rate_vs_expires(opts)
      opts.requires_fields(:option_expires_pct_year, :stock_dividend_rate_f)
      
      Math.exp(opts[:option_expires_pct_year] * -opts[:stock_dividend_rate_f])
    end


    def misc_price_vs_rate_vs_expires(opts)
      opts.requires_fields(:stock_price, :option_expires_pct_year, :stock_dividend_rate_f)
      
      opts[:stock_price] * misc_rate_vs_expires(opts)
    end
    

    def misc_strike_vs_fed_vs_expires(opts)
      opts.requires_fields(:option_strike, :option_expires_pct_year, :federal_reserve_interest_rate_f)
      
      opts[:option_strike] * Math.exp(opts[:option_expires_pct_year] * -opts[:federal_reserve_interest_rate_f])
    end
    
    
    def misc_d1(opts)
      opts.requires_fields(:price_ratio_log_less_rates, :iv, :option_expires_pct_year, :option_expires_pct_year_sqrt)
      
      return nil if opts[:iv].nil?
      
      (opts[:price_ratio_log_less_rates] + opts[:iv] * opts[:iv] * opts[:option_expires_pct_year] / 2) / (opts[:iv] * opts[:option_expires_pct_year_sqrt])
    end
   

    def misc_d2
      opts.requires_fields(:d1, :iv, :option_expires_pct_year_sqrt)
      
      return nil if opts[:iv].nil?
      
      opts[:d1] - opts[:iv] * opts[:option_expires_pct_year_sqrt]
    end

    def misc_d_normal_distribution(opts)
      opts.requires_fields(:option_type, :d_value)
      
      return nil if opts[:d_value].nil?
      
      multiplier = case opts[:option_type]
      when :call
        1.0
      when :put
        -1.0
      else
        raise ArgumentError, "Invalid option_type = #{opts[:option_type]}"
      end
      
      normal_distribution(multiplier * opts[:d_value])
    end
    
  end
end