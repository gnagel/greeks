require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::vega" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations

  before(:all) {
    @opts                     = {
      :iv                            => 7.7,
      :stock_price                   => 1614.42,
      :option_type                   => :call,
      :option_strike                 => 1615.00,
      :option_expires_pct_year       => (7.0 + 1.0) / 365.0,
      :federal_reserve_interest_rate => 0.0,
    }
  }
  
  it "should take 0.000005s per calculation" do
    test_speed(0.000005) { vega(@opts) }
  end

  it "should calculate the vega" do
    expect {vega(@opts.merge(:option_strike => 1650.00, :iv => nil))}.to raise_error ArgumentError
    vega(@opts.merge(:option_strike => 1615.00, :iv => 7.7)).should === 1.04
    vega(@opts.merge(:option_strike => 1620.00, :iv => 7.7)).should === 1.43
    vega(@opts.merge(:option_strike => 1625.00, :iv => 7.6)).should === 1.93
    vega(@opts.merge(:option_strike => 1630.00, :iv => 7.6)).should === 2.53
    vega(@opts.merge(:option_strike => 1635.00, :iv => 7.6)).should === 3.24
    vega(@opts.merge(:option_strike => 1640.00, :iv => 7.8)).should === 3.96
    vega(@opts.merge(:option_strike => 1645.00, :iv => 7.8)).should === 4.90
  end
end
