require 'rubygems'

require 'rspec'
require 'rspec-expectations'
require 'benchmark'

$:.push File.expand_path("../lib", File.dirname(__FILE__))
require 'greeks'

$spec_root = File.dirname(__FILE__)

RSpec.configure do |config|
  old_verbose, $VERBOSE = $VERBOSE, nil
  
  def puts(s)
    file = File.basename(caller(1).first)
    super("puts() from #{file}: #{s}")
  end
  
  def print(s)
    file = File.basename(caller(1).first)
    super("print() from #{file}: #{s}")
  end

  def p(s)
    file = File.basename(caller(1).first)
    super("p() from #{file}: #{s}")
  end
  
  def test_speed(x_speed, x_times = 1000)
    time = Benchmark.realtime { x_times.times { |n| @result = yield } }
    (time / x_times).should < x_speed
    @result
  end
end

module Math
  module GreekCalculationHelpers
    include Math
    include Math::GreekCalculations

    def var_du
      iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
    end

    def var_price_vs_rate_vs_expires
      iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f)
    end
  
    def var_vega
      iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)
    end
  
    def var_vega
      iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)
    end
  
    def var_option_price
      iv_option_price(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, var_du, var_price_vs_rate_vs_expires)
    end
    
    def var_iv
      iv_calc(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, option_price)
    end
  end
end