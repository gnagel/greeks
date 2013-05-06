module Math
  module GreekCalculations
    def delta!(opts = {})
      opts[:delta] = delta(opts)
    end


    def delta(opts = {})
      [
        :iv,
        :stock_price,
        :option_type,
        :option_strike,
        :option_expires_pct_year,
        :federal_reserve_interest_rate
      ].each do |required_key|
        raise ArgumentError, "Missing value for key=#{required_key} in opts=#{opts.inspect}" if opts[required_key].nil?
      end
      
      sqrt_expires = Math.sqrt(opts[:option_expires_pct_year])
      iv_sqrt_expires = opts[:iv] * sqrt_expires

      d1 = normal_distribution((Math.log(opts[:stock_price] / opts[:option_strike]) + opts[:federal_reserve_interest_rate] * t) /  iv_sqrt_expires + 0.5 * iv_sqrt_expires)
      
      d1 = d1 - 1 if opts[:option_type] === :put
      
      d1
    end
  end
end
