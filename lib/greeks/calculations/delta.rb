module Math
  module GreekCalculations
    # Delta
    # A measurement of the change in the price of an option resulting from a change in the price of the underlying security.
    # Delta is positive for calls and negative for puts. Delta can be calculated as the dollar change of the option that an
    # investor can expect for a one-dollar change in the underlying security. For example, let's say an option on a stock
    # trading at $50 costs $1 and has a delta of $0.50 per dollar of underlying stock price change. If the stock price rises
    # to $52, the price of the option will increase by $1 (the $2 price change times the $0.50 delta). After the stock price
    # movement, the option will be worth $2 ($1 initial cost plus $1 delta). Delta can also be calculated as a percentage
    # change in the option price for a one-percent change in the underlying security; this method of viewing the delta value
    # is also known as "leverage."
    def delta(opts)
      opts.requires_fields(:option_type, :rate_vs_expires, :d1_normal_distribution, :iv)

      return nil if opts[:iv].nil?

      multiplier = case opts[:option_type]
      when :call
        1.0
      when :put
        -1.0
      else
        raise "Invalid option_type = #{opts[:option_type].inspect}"
      end
      
      multiplier * opts[:rate_vs_expires] * opts[:d1_normal_distribution]
    end
  end
end
