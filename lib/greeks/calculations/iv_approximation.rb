module Math
  module GreekCalculations
    def iv_approximation!(opts = {})
      opts[:iv_approximation] = iv_approximation(opts)
    end

      
    def iv_approximation(opts = {})
      [
        :volatility_assumption,
        :stock_price,
        :stock_dividend_rate,
        :option_type,
        :option_strike,
        :option_expires_pct_year,
        :federal_reserve_interest_rate
      ].each do |required_key|
        raise ArgumentError, "Missing value for key=#{required_key} in opts=#{opts.inspect}" if opts[required_key].nil?
      end

      du = Math.log(opts[:stock_price] / opts[:option_strike]) + (opts[:federal_reserve_interest_rate] - opts[:stock_dividend_rate]) * opts[:option_expires_pct_year]

      p1 = opts[:stock_price] * Math.exp(-opts[:stock_dividend_rate] * opts[:option_expires_pct_year])

      x1 = opts[:option_strike] * Math.exp(-opts[:federal_reserve_interest_rate] * opts[:option_expires_pct_year])
      
      sqrt_expires = Math.sqrt(opts[:option_expires_pct_year])

      d1 = (du + opts[:volatility_assumption] * opts[:volatility_assumption] * opts[:option_expires_pct_year] / 2) / (opts[:volatility_assumption] * sqrt_expires)

      d2 = d1 - opts[:volatility_assumption] * sqrt_expires

      if (opts[:option_type] === :call)
        iv_approximation = p1 * normal_distribution(d1) - x1 * normal_distribution(d2)
      else
        iv_approximation = x1 * normal_distribution(-d2) - p1 * normal_distribution(-d1)
      end
      
      iv_approximation
    end
  end
end
