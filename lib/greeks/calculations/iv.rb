module Math
  module GreekCalculations
    def iv(opts)
      ImpliedVolatility.new(opts).iv
    end
    
    class ImpliedVolatility
      include Math::GreekCalculations

      def initialize(opts)
        opts.requires_fields(
          :federal_reserve_interest_rate,
          :stock_price,
          :stock_dividend_rate,
          :option_type,
          :option_strike,
          :option_price,
          :option_expires_in_days
        )
        @federal_reserve_interest_rate = opts[:federal_reserve_interest_rate]
        @stock_dividend_rate           = opts[:stock_dividend_rate]

        @option_type                   = opts[:option_type]
        @stock_price                   = opts[:stock_price]
        @option_strike                 = opts[:option_strike]
        @option_price                  = opts[:option_price]
        @option_expires_in_days        = opts[:option_expires_in_days]
        @option_days_pct_of_year       = (Float(@option_expires_in_days) + Float(1))/Float(365)
      end

      # Calculate the "raw" 0.000 to 1.000 range of the IV
      def iv()
        e = 0.0001
        n = 13
        pLim = [0.005, 0.01 * @option_price].min;

        v = Math.sqrt((Math.log(@stock_price / @option_strike) + (@federal_reserve_interest_rate - @stock_dividend_rate) * @option_days_pct_of_year).abs * 2 / @option_days_pct_of_year)
        v = 0.1 if (v <= 0)

        c = option_price_approxination(v)

        return v if ((@option_price - c).abs < pLim)

        vega = calc_vega(v)
        v1 = v - (c - @option_price) / vega
        step = 1
        while ((v - v1).abs > e && step < n)
          v = v1
          c = option_price_approxination(v)
          return v if ((@option_price - c).abs < pLim)

          vega = calc_vega(v)
          v1 = v - (c - @option_price) / vega
          return v1 if (v1 < 0)

          step= step + 1
        end

        return v1 if (step < n)

        c = option_price_approxination(v1)
        return v1 if ((@option_price - c).abs < pLim)

        nil
      end
      
      private

      # calculate vega
      def calc_vega(v)
        st = Math.sqrt(@option_days_pct_of_year)
        du = Math.log(@stock_price / @option_strike) + (@federal_reserve_interest_rate - @stock_dividend_rate) * @option_days_pct_of_year
        p1 = @stock_price * Math.exp(-@stock_dividend_rate * @option_days_pct_of_year)
        d1 = (du + v * v * @option_days_pct_of_year / 2) / (v * st)
        nd = Math.exp(-d1 * d1 / 2) / Math.sqrt(2 * Math::PI)
        vega = p1 * st * nd

        return vega
      end

      # This gives an approxination of the Implied volatility
      def option_price_approxination(v)
        st = Math.sqrt(@option_days_pct_of_year)
        du = Math.log(@stock_price / @option_strike) + (@federal_reserve_interest_rate - @stock_dividend_rate) * @option_days_pct_of_year
        p1 = @stock_price * Math.exp(-@stock_dividend_rate * @option_days_pct_of_year)
        x1 = @option_strike * Math.exp(-@federal_reserve_interest_rate * @option_days_pct_of_year)
        d1 = (du + v * v * @option_days_pct_of_year / 2) / (v * st)
        d2 = d1 - v * st

        if (@option_type === :call)
          iv_approximation = p1 * normal_distribution(d1) - x1 * normal_distribution(d2)
        else
          iv_approximation = x1 * normal_distribution(-d2) - p1 * normal_distribution(-d1)
        end
    
        return iv_approximation
      end

    end
    
  end
end
