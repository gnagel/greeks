module Math
  module GreekCalculations
    # Rho
    # The change in the value of an option for a change in the prevailing interest rate that matches the duration of the option,
    # all else held equal. Generally rho is not a big driver of price changes for options, as interest rates tend to be relatively stable.
    def rho(opts = {})
      opts.requires_fields(:option_type, :option_expires_pct_year, :strike_vs_fed_vs_expires, :d2_normal_distribution)

      multiplier = case opts[:option_type]
      when :call
        1.0
      when :put
        -1.0
      else
        raise "Invalid option_type = #{opts[:option_type].inspect}"
      end
      
      multiplier * opts[:option_expires_pct_year] * opts[:strike_vs_fed_vs_expires] * opts[:d2_normal_distribution] / 100
    end
  end
end
