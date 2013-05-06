module Math
  module GreekCalculations
    def theta!(opts = {})
      opts[:theta] = theta(opts)
    end


    def theta(opts = {})
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
      sqrt_expires2 = sqrt_expires * 2
      iv_sqrt_expires = opts[:iv] * sqrt_expires

      d1 = (Math.log(opts[:stock_price] / opts[:option_strike]) + opts[:federal_reserve_interest_rate] * opts[:option_expires_pct_year]) /  iv_sqrt_expires + 0.5 * iv_sqrt_expires
      
      ndE = normal_distribution(d1 - iv_sqrt_expires)
      ndG = normal_distribution_gaussian(d1)
      
      part1 = opts[:stock_price] * opts[:iv] * ndG
      part2 = opts[:federal_reserve_interest_rate] * opts[:option_strike] * Math.exp(-opts[:federal_reserve_interest_rate] * opts[:option_expires_pct_year])

      if (opts[:option_type] === :call)
          theta = -(part1) / (sqrt_expires2) - part2 * ndE
      else
          theta = -(part1) / (sqrt_expires2) + part2 * (1 - ndE)
      end

      theta /= 365 # Convert to daily
      
      theta
    end
  end
end
