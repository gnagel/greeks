
module Math
  module GreekCalculationShorthandHelpers
    include Math
    include Math::GreekCalculations

    def var_price_ratio_log_less_rates
      misc_price_ratio_log_less_rates(
        :stock_price                     => stock_price, 
        :option_strike                   => option_strike, 
        :option_expires_pct_year         => option_expires_pct_year, 
        :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f, 
        :stock_dividend_rate_f           => stock_dividend_rate_f
      )
    end

    def var_price_vs_rate_vs_expires
      misc_price_vs_rate_vs_expires(
        :stock_price             => stock_price, 
        :option_expires_pct_year => option_expires_pct_year, 
        :stock_dividend_rate_f   => stock_dividend_rate_f
      )
    end
  
    def var_vega
      iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_price_ratio_log_less_rates, var_price_vs_rate_vs_expires)
    end
  
    def var_vega
      iv_vega(stock_price, option_strike, option_expires_pct_year, Math::sqrt(option_expires_pct_year), volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_price_ratio_log_less_rates, var_price_vs_rate_vs_expires)
    end
  
    def var_option_price
      iv_option_price(stock_price, option_strike, option_expires_pct_year, Math::sqrt(option_expires_pct_year), volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, var_price_ratio_log_less_rates, var_price_vs_rate_vs_expires, misc_strike_vs_fed_vs_expires(:option_strike => option_strike, :option_expires_pct_year => option_expires_pct_year, :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f))
    end
    
    def var_iv
      iv(
        :stock_price                     => stock_price, 
        :option_strike                   => option_strike, 
        :option_expires_pct_year         => option_expires_pct_year, 
        :option_expires_pct_year_sqrt    => Math::sqrt(option_expires_pct_year), 
        :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f, 
        :stock_dividend_rate_f           => stock_dividend_rate_f, 
        :option_type                     => option_type,
        :option_price                    => option_price, 
        :rate_vs_expires                 => misc_rate_vs_expires(:option_expires_pct_year => option_expires_pct_year, :stock_dividend_rate_f => stock_dividend_rate_f), 
        :price_vs_rate_vs_expires        => var_price_vs_rate_vs_expires, 
        :strike_vs_fed_vs_expires        => misc_strike_vs_fed_vs_expires(:option_strike => option_strike, :option_expires_pct_year => option_expires_pct_year, :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f),
        :price_ratio_log_less_rates      => var_price_ratio_log_less_rates
      )
    end
  end
end
