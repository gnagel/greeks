module Math
  module GreekCalculations
    # Gamma
    # A measurement of the change in delta as the price of the underlying stock changes. As the underlying stock price changes,
    # the delta of the option changes, too. Gamma indicates how quickly your exposure to the price movement of the underlying
    # security changes as the price of the underlying security varies. For example, if you have a call with a strike of $50
    # and the stock price is $50, the delta likely will be approximately $0.50 for a one-dollar movement of the stock.
    # At a stock price of $60, the delta will be greater, closer to $0.75. At a stock price of $40, the delta will be less,
    # closer to $0.25. In this example, if the stock price changes from $50 to $60, then the delta will change from $0.50 to $0.75.
    # The $10 change in stock price caused a $0.25 change in delta, so gamma is approximately $0.25/10, or $0.025, in this case.
    def gamma(opts = {})
      opts.requires_keys_are_present(:iv)
      return nil if opts[:iv].nil?
      
      opts.requires_keys_are_not_nil(:stock_price, :option_expires_pct_year_sqrt, :nd1, :rate_vs_expires, :iv)
      
    	opts[:nd1] * opts[:rate_vs_expires] / (opts[:stock_price] * opts[:iv] * opts[:option_expires_pct_year_sqrt])
    end
  end
end
