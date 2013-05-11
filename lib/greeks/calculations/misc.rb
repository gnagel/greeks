module Math
  module GreekCalculations
    SQRT_2PI = Math::sqrt(2 * Math::PI)

    def p1!(opts)
      opts.requires_fields(
        :stock_price,
        :stock_dividend_rate_f,
        :option_expires_pct_year
      )

      opts[:p1] ||= opts[:stock_price] * Math::exp(-opts[:stock_dividend_rate_f] * opts[:option_expires_pct_year])
    end

    
    def eqt!(opts)
      opts.requires_fields(
        :stock_dividend_rate_f,
        :option_expires_pct_year
      )

      opts[:eqt] ||= Math::exp(-opts[:stock_dividend_rate_f] * opts[:option_expires_pct_year])
    end

    
    def du!(opts)
      opts.requires_fields(
        :stock_price,
        :stock_dividend_rate_f,
        :option_strike,
        :option_expires_pct_year,
        :federal_reserve_interest_rate_f
      )

      opts[:du] ||= Math::log(opts[:stock_price] / opts[:option_strike]) + (opts[:federal_reserve_interest_rate_f] - opts[:stock_dividend_rate_f]) * opts[:option_expires_pct_year]
    end


    def d1!(opts)
      opts.requires_fields(
        :iv,
        :option_expires_pct_year
      )

      du!(opts)

      opts[:d1] ||= (opts[:du] + opts[:iv] * opts[:iv] * opts[:option_expires_pct_year] / 2) / (opts[:iv] * opts[:option_expires_pct_year_sqrt])
    end


    def d1_normal_distribution!(opts)
      d1!(opts)

      multiplier = opts[:option_type] === :call ? 1 : -1
      opts[:d1_normal_distribution] ||= GreekCalculations.normal_distribution(multiplier * opts[:d1])
    end
    
    
    def d2!(opts)
      opts.requires_fields(:d1, :iv, :option_expires_pct_year_sqrt)
      
      opts[:d2] ||= opts[:d1] - opts[:iv] * opts[:option_expires_pct_year_sqrt]
    end

    
    def d2_normal_distribution!(opts)
      d2!(opts)
      opts[:d2_normal_distribution] ||= normal_distribution(opts[:d2])
    end
   
    def nd1!(opts)
      d1!(opts)
      opts[:nd1] ||= Math::exp(-0.5 * opts[:d1] * opts[:d1]) / SQRT_2PI
    end


    def x1!(opts)
      opts[:x1] ||= opts[:option_strike] * Math::exp(-opts[:federal_reserve_interest_rate_f] * opts[:option_expires_pct_year])
    end

  end
end