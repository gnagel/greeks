require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::vega" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations

  before(:all) {
    @opts                     = {
      :volatility_assumption         => 1.6067241201549014,
      :federal_reserve_interest_rate => 0.0,
      :stock_dividend_rate           => 0.0,
      :stock_price                   => 1558.86,
      :option_strike                 => 800.0,
      :option_expires_pct_year       => (2.0 + 1.0) / 365.0
    }
  }
  
  it "should take 0.000005s per calculation" do
    test_speed(0.000005) { vega(@opts) }
  end

  it "should calculate the vega" do
    vega(@opts.merge(:option_strike =>  800.0, :volatility_assumption => 1.6067241201549014)).should === 0.0011241039628403465
    vega(@opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.7767120139768976)).should === 56.24120981690763
    vega(@opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.17527391126836678)).should === 55.62798047373135
    vega(@opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.7767120139768976)).should === 56.24120981690763
    vega(@opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.17527391126836678)).should === 55.62798047373135
    vega(@opts.merge(:option_strike => 1560.0, :volatility_assumption => 0.42176476544518277)).should === 56.38081822198368
    vega(@opts.merge(:option_strike => 1560.0, :volatility_assumption => 0.42176476544518277)).should === 56.38081822198368
    vega(@opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.9780351979867221)).should === 56.38081822198368
    vega(@opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.1841966933132152)).should === 54.94608639051165
    vega(@opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.9780351979867221)).should === 56.38081822198368
  end
end



