require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations

  before(:all) {
    @opts = {
      :federal_reserve_interest_rate => 0.0,
      :stock_dividend_rate           => 0.0,
      :stock_price                   => 1558.86,
      :option_expires_in_days        => 2,
      :option_type                   => nil,
      :option_strike                 => nil,
      :option_price                  => nil,
    }
  }
  

  describe "call options" do
    before(:all) {
      @call_opts = @opts.merge(
        :option_type            => :call,
        :option_strike          => 1555.00,
        :option_price           => 6.00,
        :option_expires_in_days => 2
        )
    }
    
    it "should take 0.0005s per calculation" do
      test_speed(0.0005) { iv(@call_opts) }
    end

    it "should calculate the iv" do
      iv(@call_opts.merge(:option_strike => 800.00, :option_price => 751.50)).should be_nil
      iv(@call_opts.merge(:option_strike => 1555.00, :option_price => 6.00)).should === 6.7
      iv(@call_opts.merge(:option_strike => 1560.00, :option_price => 3.70)).should === 7.5
      iv(@call_opts.merge(:option_strike => 1565.00, :option_price => 2.00)).should === 7.8
    end
  end
  
  describe "put options" do
    before(:all) {
      @put_opts = @opts.merge(
        :option_type            => :put,
        :option_strike          => 1555.00,
        :option_price           => 6.00,
        :option_expires_in_days => 2,
        )
    }
    
    it "should take 0.0005s per calculation" do
      test_speed(0.0005) { iv(@put_opts) }
    end

    it "should calculate the iv" do
      iv(@put_opts.merge(:option_strike => 800.00, :option_price => 0.00)).should be_nil
      iv(@put_opts.merge(:option_strike => 1555.00, :option_price => 8.00)).should === 17.4
      iv(@put_opts.merge(:option_strike => 1560.00, :option_price => 10.40)).should === 17.4
      iv(@put_opts.merge(:option_strike => 1565.00, :option_price => 13.60)).should === 18.1
    end
  end
end
