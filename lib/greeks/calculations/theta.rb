module Math
  module GreekCalculations
    def theta(opts = {})
      opts.requires_fields(:stock_dividend_rate_f, :federal_reserve_interest_rate_f, :option_type, :option_expires_pct_year_sqrt, :iv, :strike_vs_fed_vs_expires, :price_vs_rate_vs_expires, :nd1, :d1_normal_distribution, :d2_normal_distribution)
      
      return nil if opts[:iv].nil?
      
      part0 = opts[:price_vs_rate_vs_expires] * opts[:nd1] * opts[:iv]
      part1 = 2 * opts[:option_expires_pct_year_sqrt]
      part2 = opts[:stock_dividend_rate_f]           * opts[:price_vs_rate_vs_expires] * opts[:d1_normal_distribution]
      part3 = opts[:federal_reserve_interest_rate_f] * opts[:strike_vs_fed_vs_expires] * opts[:d2_normal_distribution]
      
      case opts[:option_type]
      when :call
        return (-part0 / part1 + part2 - part3) / 365
      when :put
        return (-part0 / part1 - part2 + part3) / 365
      else
        raise "Invalid option_type = #{opts[:option_type].inspect}"
      end
    end
  end
end
