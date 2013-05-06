module Math
  module GreekCalculations
    def rho!(opts = {})
      opts[:rho] = rho(opts)
    end


    def rho(opts = {})
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

      d1 = (Math.log(opts[:stock_price] / opts[:option_strike]) + opts[:federal_reserve_interest_rate] * t) /  iv_sqrt_expires + 0.5 * iv_sqrt_expires
      
      ndE = normal_distribution(d1 - iv_sqrt_expires)
      ndG = normal_distribution_gaussian(d1)
      
      part1 = opts[:option_strike] * opts[:option_expires_pct_year]
      part2 = Math.exp(-opts[:federal_reserve_interest_rate] * opts[:option_expires_pct_year])

      if (opts[:option_type] === :call)
          rho = 0.01 * part1 * part2 * ndE
      else
          rho = -0.01 * part1 * part2 * (1 - ndE)
      end
      
      rho
    end
  end
end
