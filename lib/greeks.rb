require 'rubygems'
require 'hash_plus'

require_relative 'greeks/calculations/delta'
require_relative 'greeks/calculations/gamma'
require_relative 'greeks/calculations/iv'
require_relative 'greeks/calculations/normal_distribution'
require_relative 'greeks/calculations/theta'
require_relative 'greeks/calculations/rho'
require_relative 'greeks/calculations/vega'
require_relative 'greeks/calculations/time_values'


module Math
  module Greeks
    class Calculator
      class GreekCalculations
        extend Math::GreekCalculations
      end

      attr_reader :stock_price
      attr_reader :stock_dividend_rate
      attr_reader :option_type  # :call, or :put
      attr_reader :option_price # bid, mid, or ask
      attr_reader :option_strike
      attr_reader :option_expires_in_days
      attr_reader :federal_reserve_interest_rate

      attr_reader :option_expires_pct_year
      attr_reader :option_expires_pct_year_sqrt
      attr_reader :stock_dividend_rate_f
      attr_reader :federal_reserve_interest_rate_f
      attr_reader :rate_vs_expires
      attr_reader :price_vs_rate_vs_expires
      attr_reader :strike_vs_fed_vs_expires
      attr_reader :price_ratio_log_less_rates


      def initialize(opts)
        @stock_price                   = opts[:stock_price]
        @stock_dividend_rate           = opts[:stock_dividend_rate]
        @option_type                   = opts[:option_type]
        @option_price                  = opts[:option_price]
        @option_strike                 = opts[:option_strike]
        @option_expires_in_days        = opts[:option_expires_in_days]
        @federal_reserve_interest_rate = opts[:federal_reserve_interest_rate]
        
        @federal_reserve_interest_rate_f = federal_reserve_interest_rate / 100.0
        @stock_dividend_rate_f           = stock_dividend_rate / 100.0
        @option_expires_pct_year         = (option_expires_in_days + 1.0) / 365.0
        @option_expires_pct_year_sqrt    = Math.sqrt(option_expires_pct_year)
        
        
        @price_vs_rate_vs_expires = GreekCalculations.misc_price_vs_rate_vs_expires(
          :stock_price             => stock_price,
          :stock_dividend_rate_f   => stock_dividend_rate_f,
          :option_expires_pct_year => option_expires_pct_year
        )

        @rate_vs_expires = GreekCalculations.misc_rate_vs_expires(
          :option_expires_pct_year => option_expires_pct_year, 
          :stock_dividend_rate_f   => stock_dividend_rate_f
        )
        
        @strike_vs_fed_vs_expires = GreekCalculations.misc_strike_vs_fed_vs_expires(
          :option_strike                   => option_strike,
          :option_expires_pct_year         => option_expires_pct_year, 
          :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f
        )
        
        @price_ratio_log_less_rates = GreekCalculations.misc_price_ratio_log_less_rates(
          :stock_price                     => stock_price, 
          :stock_dividend_rate_f           => stock_dividend_rate_f, 
          :option_strike                   => option_strike, 
          :option_expires_pct_year         => option_expires_pct_year, 
          :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f
        )
      end


      # Chance of Breakeven
      # The probability that a stock will be trading beyond the breakeven price as implied by the option price.
      # Chance of Breakeven can be used to get a sense for the valuation of the option by comparing the markets'
      # estimate of Chance of Breakeven to estimates derived from your own fundamental research.
      # If you believe the Chance of Breakeven is less than the probability that a stock will be beyond the
      # breakeven price at option expiration, then you believe the option is undervalued, and visa versa.
      def break_even
        @break_even ||= GreekCalculations.break_even(
          :stock_price                     => stock_price, 
          :stock_dividend_rate_f           => stock_dividend_rate_f, 
          :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f, 
          :option_type                     => option_type, 
          :option_price                    => option_price, 
          :option_strike                   => option_strike, 
          :option_expires_pct_year         => option_expires_pct_year, 
          :option_expires_pct_year_sqrt    => option_expires_pct_year_sqrt, 
          :iv                              => iv
        )
      end


      # Intrinsic Value
      # The value that the option would pay if it were executed today. For example, if a stock is trading at $40,
      # a call on that stock with a strike price of $35 would have $5 of intrinsic value ($40-$35) if it were 
      # exercised today. However, the call should actually be worth more than $5 to account for the value of the 
      # chance of any further appreciation until expiration, and the difference between the price and the 
      # intrinsic value would be the time value.
      def premium_value
        @premium_value ||= GreekCalculations.premium_value(
          :option_type   => option_type,
          :option_strike => option_strike,
          :stock_price   => stock_price
        )
      end


      # Time Value
      # The value of an option that captures the chance of further appreciation before expiration.
      # The value of an option can be broken down into intrinsic value, or the value of the option 
      # if it were exercised today, and time value, or the added value of the option over and above
      # the intrinsic value. For example, if a stock is trading at $40 and a call with a strike price
      # of $35 were trading for $7, the call would have a $5 intrinsic value ($40-$35) and a $2 time value ($7-$5). 
      # Time value will decay by expiration assuming the underlying security stays at the same price.
      def time_value
        @time_value ||= GreekCalculations.time_value(
          :option_price  => option_price,
          :premium_value => premium_value
        )
      end


      # Annualized Premium
      # The annualized premium is the value of the option divided by the strike price. You can use annualized 
      # premium to develop an intuitive understanding of how much the market is "paying" for a dollar of risk. 
      # For example, if a stock is trading at $50 and you sell a $50 strike 6 month call for $4, you are getting
      # paid 8% in 6 months, or about 16% annualized, in exchange for being willing to buy at $50, the current price.
      def annualized_premium_value
        @annualized_premium_value ||= GreekCalculations.annualized_premium_value(
          :option_price            => option_price,
          :option_strike           => option_strike,
          :option_expires_pct_year => option_expires_pct_year
        )
      end


      # Annualized Time Value
      # The time value of the option divided by the strike price, then annualized. You can use annualized 
      # time value to develop an intuitive understanding of how much value the option market is adding to
      # an in-the-money option beyond the intrinsic value. For example, if a stock is trading at $40 and a
      # six month call on that stock with a strike price of $35 has an intrinsic value of $5 and a total 
      # value of $7, the time value ($2) divided by the strike is ($2/$40) = 5%. Annualizing that time value 
      # to a one year horizon on a continuously compounded basis yields 9.76% (2 × ln(1 + 0.05)).
      def annualized_time_value
        @annualized_time_value ||= GreekCalculations.annualized_time_value(
          :time_value              => time_value,
          :option_strike           => option_strike,
          :option_expires_pct_year => option_expires_pct_year
        )
      end


      # Implied Volatility
      # A measure of the "riskiness" of the underlying security. Implied volatility is the primary measure of
      # the "price" of an option--how expensive it is relative to other options. It is the "plug" value in option
      # pricing models (the only variable in the equation that isn't precisely known). The remaining variables are
      # option price, stock price, strike price, time to expiration, interest rate, and estimated dividends. 
      # Therefore, the implied volatility is the component of the option price that is determined by the market.
      # Implied volatility is greater if the future outcome of the underlying stock price is more uncertain.
      # All else equal, the wider the market expects the range of possible outcomes to be for a stock's price,
      # the higher the implied volatility, and the more expensive the option.
      def iv
        @iv ||= GreekCalculations.iv(
          :stock_price                     => stock_price,
          :stock_dividend_rate             => stock_dividend_rate,
          :stock_dividend_rate_f           => stock_dividend_rate_f,
          :option_type                     => option_type,
          :option_price                    => option_price,
          :option_strike                   => option_strike,
          :option_expires_in_days          => option_expires_in_days,
          :option_expires_pct_year         => option_expires_pct_year,
          :option_expires_pct_year_sqrt    => option_expires_pct_year_sqrt,
          :federal_reserve_interest_rate   => federal_reserve_interest_rate,
          :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f,
          :price_ratio_log_less_rates      => price_ratio_log_less_rates,
          :rate_vs_expires                 => rate_vs_expires,
          :strike_vs_fed_vs_expires        => strike_vs_fed_vs_expires,
          :price_vs_rate_vs_expires        => price_vs_rate_vs_expires,
        )
      end


      # Delta
      # A measurement of the change in the price of an option resulting from a change in the price of the underlying security.
      # Delta is positive for calls and negative for puts. Delta can be calculated as the dollar change of the option that an
      # investor can expect for a one-dollar change in the underlying security. For example, let's say an option on a stock
      # trading at $50 costs $1 and has a delta of $0.50 per dollar of underlying stock price change. If the stock price rises
      # to $52, the price of the option will increase by $1 (the $2 price change times the $0.50 delta). After the stock price
      # movement, the option will be worth $2 ($1 initial cost plus $1 delta). Delta can also be calculated as a percentage
      # change in the option price for a one-percent change in the underlying security; this method of viewing the delta value
      # is also known as "leverage."
      def delta
        @delta ||= GreekCalculations.delta(
          :option_type            => option_type, 
          :iv                     => iv,
          :rate_vs_expires        => rate_vs_expires, 
          :d1_normal_distribution => d1_normal_distribution
        )
      end


      # Gamma
      # A measurement of the change in delta as the price of the underlying stock changes. As the underlying stock price changes,
      # the delta of the option changes, too. Gamma indicates how quickly your exposure to the price movement of the underlying
      # security changes as the price of the underlying security varies. For example, if you have a call with a strike of $50
      # and the stock price is $50, the delta likely will be approximately $0.50 for a one-dollar movement of the stock.
      # At a stock price of $60, the delta will be greater, closer to $0.75. At a stock price of $40, the delta will be less,
      # closer to $0.25. In this example, if the stock price changes from $50 to $60, then the delta will change from $0.50 to $0.75.
      # The $10 change in stock price caused a $0.25 change in delta, so gamma is approximately $0.25/10, or $0.025, in this case.
      def gamma
        @gamma ||= GreekCalculations.gamma(
          :stock_price                  => stock_price, 
          :option_expires_pct_year_sqrt => option_expires_pct_year_sqrt, 
          :iv                           => iv, 
          :nd1                          => nd1, 
          :rate_vs_expires              => rate_vs_expires
        )
      end


      # Vega
      # The change in the price of an option for a change in the implied volatility of the option, all else held equal.
      # In general, as the options market thinks it is more difficult to value a stock, implied volatility and therefore
      # the price of the options will increase. For example, if an option is trading for $1, the implied volatility is 20%,
      # and the vega is $0.05, then a one-percentage-point increase in implied volatility to 21% would correspond to an increase in
      # the price of the option to $1.05. In percentage terms, the vega in this case would be ($0.05/$1.00)/(1 percentage point) = 5%.
      def vega
        @vega ||= GreekCalculations.vega(
          :price_vs_rate_vs_expires     => price_vs_rate_vs_expires, 
          :option_expires_pct_year_sqrt => option_expires_pct_year_sqrt,
          :nd1                          => nd1, 
          :iv                           => iv
        )
      end


      # Rho
      # The change in the value of an option for a change in the prevailing interest rate that matches the duration of the option,
      # all else held equal. Generally rho is not a big driver of price changes for options, as interest rates tend to be relatively stable.
      def rho
        @rho ||= GreekCalculations.rho(
          :option_type              => option_type, 
          :option_expires_pct_year  => option_expires_pct_year, 
          :strike_vs_fed_vs_expires => strike_vs_fed_vs_expires, 
          :d2_normal_distribution   => d2_normal_distribution,
          :iv                       => iv
        )
      end


      # Theta
      # The change in an option's value that an investor can expect from the passage of one day, assuming nothing else changes.
      # Theta can be calculated in two ways, as the dollar change of the option that an investor can expect for a one-day passage of time,
      # all else remaining equal, or as a percentage change in the option price for a one-day passage of time, all else remaining equal.
      # For example, if an option trades at $1 on Monday morning and it has a theta of -$0.10 per day, you can expect the option to trade
      # at $0.90 on Tuesday morning. Another way of measuring theta for that option is ($0.90 - $1)/$1 or -10% per day.
      def theta
        @theta ||= GreekCalculations.theta(
          :federal_reserve_interest_rate_f => federal_reserve_interest_rate_f, 
          :stock_dividend_rate_f           => stock_dividend_rate_f, 
          :option_type                     => option_type, 
          :option_expires_pct_year_sqrt    => option_expires_pct_year_sqrt, 
          :strike_vs_fed_vs_expires        => strike_vs_fed_vs_expires, 
          :price_vs_rate_vs_expires        => price_vs_rate_vs_expires, 
          :price_ratio_log_less_rates      => price_ratio_log_less_rates,
          :iv                              => iv, 
          :nd1                             => nd1, 
          :d1_normal_distribution          => d1_normal_distribution, 
          :d2_normal_distribution          => d2_normal_distribution
        )
      end
      

      def to_hash
        return @hash if @hash
        @hash = {
          :federal_reserve_interest_rate => federal_reserve_interest_rate,
          :stock_dividend_rate           => stock_dividend_rate,
          :stock_price                   => stock_price,
          :option_expires_in_days        => option_expires_in_days,
          :option_type                   => option_type,
          :option_strike                 => option_strike,
          :option_price                  => option_price,
          :premium_value                 => premium_value,
          :time_value                    => time_value,
          :annualized_premium_value      => annualized_premium_value,
          :annualized_time_value         => annualized_time_value,
          :iv                            => (NilMath.new(iv)         * 100.0).to_f,                      # iv * 100
          :delta                         => (NilMath.new(delta)      * stock_price / option_price).to_f, # delta * stock_price / option_price
          :gamma                         => (NilMath.new(gamma)      * stock_price / delta).to_f,        # gamma * stock_price / delta
          :vega                          => (NilMath.new(vega)       * 100.0 * iv / option_price).to_f,  # vega * iv * 100 / option_price
          :rho                           => (NilMath.new(rho)        * 100.0 / option_price).to_f,       # rho * 100 / option_price
          :theta                         => (NilMath.new(theta)      * 100.0 / option_price).to_f,       # theta * 100 / option_price
          :delta_vs_theta                => nil,
          :break_even                    => (NilMath.new(break_even) * 100.0).to_f,                      # break_even * 100
        }

        # Delta/Theta
        # A measure of the “bang for the buck” of an option.
        # By dividing the dimensionless Delta or leverage of an option by the dimensionless Theta or 
        # decay rate, the trend in the Delta/Theta column indicates which options give the most exposure
        # to the movement of the underlying stock or index for a given decay rate of the option value.
        # The highest numbers indicate the most bang for the buck for the least decay rate.
        @hash[:delta_vs_theta] = (NilMath.new(@hash[:delta]) / @hash[:theta]).to_f

        # Iterate the generated columns and round the output
        # Skip all the fields related to the input data: Federal, Stock, & Option
        @hash.keys.reject do |key| 
          key = key.to_s
          key.start_with?('federal_') || key.start_with?('stock_') || key.start_with?('option_')
        end.each do |key|
          @hash[key] &&= @hash[key].round(2)
        end

        @hash
      end
      

      private

      
      def d1
        @d1 ||= GreekCalculations.misc_d1(
          :price_ratio_log_less_rates   => price_ratio_log_less_rates, 
          :option_expires_pct_year      => option_expires_pct_year, 
          :option_expires_pct_year_sqrt => option_expires_pct_year_sqrt,
          :iv                           => iv
        )
      end


      def d2
        @d2 ||= GreekCalculations.misc_d2(
          :option_expires_pct_year_sqrt => option_expires_pct_year_sqrt,
          :d1                           => d1,
          :iv                           => iv
        )
      end


      def d1_normal_distribution
        @d1_normal_distribution ||= GreekCalculations.misc_d_normal_distribution(
          :option_type => option_type, 
          :d_value     => d1
        )
      end


      def d2_normal_distribution
        @d2_normal_distribution ||= GreekCalculations.misc_d_normal_distribution(
          :option_type => option_type, 
          :d_value     => d2
        )
      end


      def nd1
        @nd1 ||= GreekCalculations.misc_nd1(:d1 => d1)
      end

      class NilMath
        def initialize(value)
          @value = value
        end
        
        def to_f
          @value
        end
        
        def *(input)
          multiply(input)
        end
        
        def /(input)
          divide(input)
        end
        
        def multiply(input)
          if (@value.nil? || input.nil?)
            @value = nil
          else
            @value *= input
          end
          self
        end
        
        def multiply100()
          multiply(100.0)
        end
        
        def divide(input)
          if (@value.nil? || input.nil?)
            @value = nil
          else
            @value /= input
          end
          self
        end
      end

    end
  end
end
