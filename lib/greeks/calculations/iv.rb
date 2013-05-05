module Math
  module GreekCalculations
    def iv(opts = {})
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
      
      raise NotImplementedError
    end
  end
end
