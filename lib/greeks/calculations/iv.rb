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
      step = 1

      iv_volatility_assumption_seed!(opts)
      
      iv_approximation!(opts)
      return opts[:volatility_assumption] if iv_terminal_value?(opts, pLim)

      vega!(opts)
      iv_volatility_assumption_calc!(opts)

      while ((opts[:volatility_assumption] - opts[:volatility_assumption]).abs > e && step < n)
        iv_approximation!(opts)
        return opts[:volatility_assumption] if iv_terminal_value?(opts, pLim)

        vega!(opts)
        iv_volatility_assumption_calc!(opts)
        return opts[:volatility_assumption] if (opts[:volatility_assumption] < 0)

        step += 1
      end

      return opts[:volatility_assumption] if (step < n)

      iv_approximation!(opts)
      opts.delete(:volatility_assumption) unless iv_terminal_value?(opts, pLim)
      opts[:volatility_assumption]
    end
    

    def iv_pct(opts = {})
      iv_value = iv(opts)
      return nil if iv_value.nil? || iv_value <= 0
      
      (iv_value * 100).round(2)
    end
      
    
    def iv_terminal_value?(opts, pLim)
      (opts[:option_price] - opts[:iv_approximation]).abs < pLim
    end

    
    def iv_volatility_assumption_seed!(opts)
      opts[:volatility_assumption] = Math.sqrt(
        (
          Math.log(opts[:stock_price] / opts[:option_price]) + 
          (opts[:federal_reserve_interest_rate] - opts[:stock_dividend_rate]) * 
          opts[:option_expires_pct_year]
        ).abs * 
        2 / opts[:option_expires_pct_year]
        )
      opts[:volatility_assumption] = 0.1 if (opts[:volatility_assumption] <= 0)
      
      opts[:volatility_assumption]
    end


    def iv_volatility_assumption_calc!(opts)
      opts[:volatility_assumption] = opts[:volatility_assumption] - (opts[:iv_approximation] - opts[:option_price]) / opts[:vega]
    end
  end
end
