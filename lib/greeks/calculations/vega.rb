module Math
  module GreekCalculations
    def vega(opts = {})
      [
        :volatility_assumption,
        :stock_price,
        :stock_dividend_rate,
        :option_strike,
        :option_expires_pct_year,
        :federal_reserve_interest_rate
      ].each do |required_key|
        raise ArgumentError, "Missing value for key=#{required_key} in opts=#{opts.inspect}" if opts[required_key].nil?
      end

      du = Math.log(opts[:stock_price] / opts[:option_strike]) + (opts[:federal_reserve_interest_rate] - opts[:stock_dividend_rate]) * opts[:option_expires_pct_year]

      p1 = opts[:stock_price] * Math.exp(-opts[:stock_dividend_rate] * opts[:option_expires_pct_year])
      
      sqrt_expires = Math.sqrt(opts[:option_expires_pct_year])

      d1 = (du + opts[:volatility_assumption] * opts[:volatility_assumption] * opts[:option_expires_pct_year] / 2) / (opts[:volatility_assumption] * sqrt_expires)

      nd = Math.exp(-d1 * d1 / 2) / Math.sqrt(2 * Math::PI)
      return p1 * sqrt_expires * nd
    end
  end
end
