module Math
  module Greeks
    class Calculator
      attr_accessor :stock_price
      attr_accessor :stock_dividend_rate
      attr_accessor :option_type  # :call, or :put
      attr_accessor :option_price # bid, mid, or ask
      attr_accessor :option_strike
      attr_accessor :option_expires_in_days
      attr_accessor :option_expires_pct_year
      attr_accessor :federal_reserve_interest_rate
    
      def initialize(opts = {})
        opts[:stock_dividend_rate]           ||= 0.0
        opts[:federal_reserve_interest_rate] ||= 0.0
      
        [
          :stock_price,
          :stock_dividend_rate,
          :option_type,
          :option_price,
          :option_strike,
          :option_expires_in_days,
          :federal_reserve_interest_rate
        ].each do |required_key|
          raise ArgumentError, "Missing value for key=#{required_key} in opts=#{opts.inspect}" if opts[required_key].nil?
        end
      
        @stock_price                   = opts[:stock_price]
        @stock_dividend_rate           = opts[:stock_dividend_rate]
        @option_type                   = opts[:option_type]
        @option_price                  = opts[:option_price]
        @option_strike                 = opts[:option_strike]
        @option_expires_in_days        = opts[:option_expires_in_days]
        @federal_reserve_interest_rate = opts[:federal_reserve_interest_rate]
        @option_expires_pct_year       = (option_expires_in_days.to_f + 1.0)/365.0
      end
    
      def delta
        raise NotImplementedError
      end
    
      def gamma
        raise NotImplementedError
      end
    
      def iv
        raise NotImplementedError
      end
    
      def rho
        raise NotImplementedError
      end
    
      def theta
        raise NotImplementedError
      end
    
      def vega
        raise NotImplementedError
      end
      
    end
  end
end
