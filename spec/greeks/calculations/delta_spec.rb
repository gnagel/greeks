require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::delta" do
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
    test_speed(0.000005) { delta(@opts) }
  end

  it "should calculate the delta" do
    expect {delta(@opts.merge(:option_strike => 1650.00, :iv => nil))}.to raise_error ArgumentError
    delta(@opts.merge(:option_strike => 1615.00, :iv => 7.7)).should === 111.4
    delta(@opts.merge(:option_strike => 1620.00, :iv => 7.7)).should === 126.3
    delta(@opts.merge(:option_strike => 1625.00, :iv => 7.6)).should === 143.1
    delta(@opts.merge(:option_strike => 1630.00, :iv => 7.6)).should === 160.2
    delta(@opts.merge(:option_strike => 1635.00, :iv => 7.6)).should === 177.4
    delta(@opts.merge(:option_strike => 1640.00, :iv => 7.8)).should === 188.7
    delta(@opts.merge(:option_strike => 1645.00, :iv => 7.8)).should === 208.4
  end
end
