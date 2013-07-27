module Math
  module GreekCalculations

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

    def misc_d_normal_distribution(opts)
      opts.requires_keys_are_present(:d_value)
      return nil if opts[:d_value].nil?

      opts.requires_keys_are_not_nil(:option_type, :d_value)
      
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