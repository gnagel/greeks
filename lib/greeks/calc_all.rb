module Math
  module Greeks
    class CalculatorAll
      SQRT_2PI = Math::sqrt(2 * Math::PI)
      
      class GreekCalculations
        extend  Math::GreekCalculations
      end
      
      
      attr_accessor :stock_price
      attr_accessor :stock_dividend_rate
      attr_accessor :option_type  # :call, or :put
      attr_accessor :option_price # bid, mid, or ask
      attr_accessor :option_strike
      attr_accessor :option_expires_in_days
      attr_accessor :federal_reserve_interest_rate
      
      def initialize(opts = {})
        @stock_price                   = opts[:stock_price]
        @stock_dividend_rate           = opts[:stock_dividend_rate]
        @option_type                   = opts[:option_type]
        @option_price                  = opts[:option_price]
        @option_strike                 = opts[:option_strike]
        @option_expires_in_days        = opts[:option_expires_in_days]
        @federal_reserve_interest_rate = opts[:federal_reserve_interest_rate]
      end

      def option_expires_pct_year
        @option_expires_pct_year ||= (option_expires_in_days + 1.0) / 365.0
      end

      def option_expires_pct_year0
        @option_expires_pct_year0 ||= (option_expires_in_days + 2.0) / 365.0
      end
      
      def option_expires_pct_year_sqrt
        @option_expires_pct_year_sqrt ||= Math::sqrt(option_expires_pct_year)
      end
      
      def stock_dividend_rate_f
        @stock_dividend_rate_f ||= stock_dividend_rate / 100.0
      end
      
      def federal_reserve_interest_rate_f
        @federal_reserve_interest_rate_f ||= federal_reserve_interest_rate / 100.0
      end
      
      def break_even_pct
        return nil if option_price.nil? || option_price < 0
        
        if (option_type === :call)
          @break_even_pct ||= ((option_strike + option_price) / stock_price - 1.0) * 100.0;
        else
          @break_even_pct ||= ((option_strike - option_price) / stock_price - 1.0) * 100.0;
        end
        
        @break_even_pct
      end
      
      def premium_value
        if (option_type === :call)
          @premium_value ||= max(stock_price - option_strike, 0)
        else
          @premium_value ||= max(option_strike - stock_price, 0)
        end

        @premium_value
      end
      
      def time_value
        return nil if option_price.nil? || option_price < 0
        
        @time_value ||= option_price - premium_value

        value_if_gte_0(@time_value)
      end
      
      def annualized_premium_value
        return nil if option_price.nil? || option_price < 0
        
        @annualized_premium_value ||= 100 * Math::log(1 + option_price / option_strike) / option_expires_pct_year;

        value_if_gte_0(@annualized_premium_value)
      end
      
      def annualized_time_value
        return nil if time_value.nil?
        
        @annualized_time_value ||= 100 * Math::log(1.0 + time_value / option_strike) / option_expires_pct_year
        
        value_if_gte_0(@annualized_time_value)
      end
      
      def iv
        return nil if option_price.nil? || option_price < 0
        
        @iv ||= GreekCalculations.iv(
          :stock_price                   => stock_price,
          :stock_dividend_rate           => stock_dividend_rate,
          :option_type                   => option_type,
          :option_price                  => option_price,
          :option_strike                 => option_strike,
          :option_expires_in_days        => option_expires_in_days,
          :federal_reserve_interest_rate => federal_reserve_interest_rate
        )
        
        @iv
      end
      
      def delta
        return nil if iv.nil?
        
        if (option_type === :call)
          @delta ||= eqt * d1_normal_distribution
        else
          @delta ||= -eqt * d1_normal_distribution
        end
        
        @delta
      end
      
      def gamma
        return nil if iv.nil?
        
      	@gamma ||= nd1 * eqt / (stock_price * iv * option_expires_pct_year_sqrt)

        @gamma
      end

      def vega
        return nil if iv.nil?
        
      	@vega ||= p1 * option_expires_pct_year_sqrt * nd1 / 100

        @vega
      end

      def rho
        return nil if iv.nil?
        
        if (option_type === :call)
          @rho ||= option_expires_pct_year * x1 * d2_normal_distribution / 100
        else
          @rho ||= -option_expires_pct_year * x1 * d2_normal_distribution / 100
        end

        @rho
      end

      def theta
        return nil if iv.nil?
        
        if (option_type === :call)
          @theta ||= (-p1 * nd1 * iv / (2 * option_expires_pct_year_sqrt) + stock_dividend_rate_f * p1 * d1_normal_distribution - federal_reserve_interest_rate_f * x1 * d2_normal_distribution) / 365
        else
          @theta ||= (-p1 * nd1 * iv / (2 * option_expires_pct_year_sqrt) - stock_dividend_rate_f * p1 * d1_normal_distribution + federal_reserve_interest_rate_f * x1 * d2_normal_distribution) / 365
        end

        @theta
      end
      
      def to_hash
        hash = {
          :federal_reserve_interest_rate => federal_reserve_interest_rate,
          :stock_dividend_rate           => stock_dividend_rate,
          :stock_price                   => stock_price,
          :option_expires_in_days        => option_expires_in_days,
          :option_type                   => option_type,
          :option_strike                 => option_strike,
          :option_price                  => option_price,
          :iv            => nil,
          :delta         => nil,
          :gamma         => nil, 
          :vega          => nil, 
          :rho           => nil,
          :theta         => nil,
          :deta_vs_theta => nil,
        }

        hash[:iv]            = iv * 100 unless iv.nil?
        hash[:delta]         = delta * stock_price / option_price unless delta.nil?
        hash[:gamma]         = gamma * stock_price / delta unless gamma.nil?
        hash[:vega]          = vega * iv * 100 / option_price unless vega.nil?
        hash[:rho]           = rho * 100 / option_price unless rho.nil?
        hash[:theta]         = theta * 100 / option_price unless theta.nil?
        hash[:deta_vs_theta] = hash[:delta] / hash[:theta] unless hash[:delta].nil? || hash[:theta].nil?
        
        [:iv, :delta, :gamma, :vega, :rho, :theta, :deta_vs_theta].each do |key|
          hash[key] &&= hash[key].round(2)
        end

        hash
      end

      # Delta/Theta
      # A measure of the “bang for the buck” of an option. By dividing the dimensionless Delta or leverage of an option by the dimensionless Theta or decay rate, the trend in the Delta/Theta column indicates which options give the most exposure to the movement of the underlying stock or index for a given decay rate of the option value. The highest numbers indicate the most bang for the buck for the least decay rate.
      def delta_vs_theta
      	delta / theta unless theta.nil?
      end
      
      def p1
        @p1 ||= stock_price * Math::exp(-stock_dividend_rate_f * option_expires_pct_year)
      end
      
      def eqt
        @eqt ||= Math::exp(-stock_dividend_rate_f * option_expires_pct_year)
      end
      
      def du
        @du ||= Math::log(stock_price / option_strike) + (federal_reserve_interest_rate_f - stock_dividend_rate_f) * option_expires_pct_year
      end
      
      def x1
        @x1 ||= option_strike * Math::exp(-federal_reserve_interest_rate_f * option_expires_pct_year)
      end
      
      def d1
        @d1 ||= (du + iv * iv * option_expires_pct_year / 2) / (iv * option_expires_pct_year_sqrt)
      end

      def d2
        @d2 ||= d1 - iv * option_expires_pct_year_sqrt
      end

      def d1_normal_distribution
        if (option_type === :call)
          @d1_normal_distribution ||= GreekCalculations.normal_distribution(d1)
        else
          @d1_normal_distribution ||= GreekCalculations.normal_distribution(-d1)
        end

        @d1_normal_distribution
      end

      def d2_normal_distribution
        if (option_type === :call)
          @d2_normal_distribution ||= GreekCalculations.normal_distribution(d2)
        else
          @d2_normal_distribution ||= GreekCalculations.normal_distribution(-d2)
        end

        @d2_normal_distribution
      end

      def nd1
        @nd1 ||= Math::exp(-0.5 * d1 * d1) / SQRT_2PI
      end
      
      def value_if_gte_0(value)
        value.nil? || value.to_f < 0.0 ? nil : value
      end
      
      def max(a, b)
        [a, b].max
      end
      
      def min(a, b)
        [a, b].min
      end
    end
  end
end
