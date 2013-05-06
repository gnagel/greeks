module Math
  module GreekCalculations
    def iv(opts = {})
      [
        :stock_price,
        :stock_dividend_rate,
        :option_type,
        :option_price,
        :option_strike,
        :option_expires_pct_year,
        :federal_reserve_interest_rate
      ].each do |required_key|
        raise ArgumentError, "Missing value for key=#{required_key} in opts=#{opts.inspect}" if opts[required_key].nil?
      end


      e    = 0.0001
      n    = 13
      pLim = [0.005, 0.01 * opts[:option_price]].min;

      v    = Math.sqrt((Math.log(opts[:stock_price] / opts[:option_strike]) + (opts[:federal_reserve_interest_rate] - opts[:stock_dividend_rate]) * opts[:option_expires_pct_year]).abs * 2 / opts[:option_expires_pct_year])
      v    = 0.1 if (v <= 0)

      c    = iv_approximation(opts.merge(:volatility_assumption => v))

      return v if ((opts[:option_price] - c).abs < pLim)

      calc_vega = vega(opts.merge(:volatility_assumption => v))
      v1 = v - (c - opts[:option_price]) / calc_vega
      step = 1
      while ((v - v1).abs > e && step < n)
        v         = v1
        c         = iv_approximation(opts.merge(:volatility_assumption => v))
        return v if ((opts[:option_price] - c).abs < pLim)

        calc_vega = vega(opts.merge(:volatility_assumption => v))
        v1        = v - (c - opts[:option_price]) / calc_vega
        return v1 if (v1 < 0)

        step= step + 1
      end

      return v1 if (step < n)

      c = iv_approximation(opts.merge(:volatility_assumption => v1))
      return v1 if ((opts[:option_price] - c).abs < pLim)
      return nil
    end
    

    def iv_pct(opts = {})
      iv_value = iv(opts)
      return nil if iv_value.nil? || iv_value <= 0
      
      (iv_value * 100).round(2)
    end
    
  end
end
