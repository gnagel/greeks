module Math
  module GreekCalculations
    # Vega
    # The change in the price of an option for a change in the implied volatility of the option, all else held equal.
    # In general, as the options market thinks it is more difficult to value a stock, implied volatility and therefore
    # the price of the options will increase. For example, if an option is trading for $1, the implied volatility is 20%,
    # and the vega is $0.05, then a one-percentage-point increase in implied volatility to 21% would correspond to an increase in
    # the price of the option to $1.05. In percentage terms, the vega in this case would be ($0.05/$1.00)/(1 percentage point) = 5%.
    def vega(opts = {})
      opts.requires_keys_are_present(:iv)
      return nil if opts[:iv].nil?
      
      opts.requires_keys_are_not_nil(:price_vs_rate_vs_expires, :nd1, :option_expires_pct_year_sqrt, :iv)

      opts[:price_vs_rate_vs_expires] * opts[:option_expires_pct_year_sqrt] * opts[:nd1] / 100
    end
  end
end
