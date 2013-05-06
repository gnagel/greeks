require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations

  before(:all) {
    @opts = {
      :federal_reserve_interest_rate => 0.0,
      :stock_dividend_rate           => 0.0,
      :stock_price                   => 1558.86,
      :option_expires_pct_year       => (2.0 + 1.0) / 365.0,
      :option_type                   => nil,
      :option_strike                 => 1555.00,
      :option_price                  => 6.00,
    }
  }


  describe "call options" do
    before(:all) {
      @call_opts = @opts.merge(:option_type => :call)
    }
    
    it "should take 0.0005s per calculation" do
      test_speed(0.0005) { iv_pct(@call_opts) }
    end

    it "should calculate the iv" do
      iv_pct(@call_opts.merge(:option_strike =>  800.00, :option_price => 751.50)).should be_nil
      iv_pct(@call_opts.merge(:option_strike => 1555.00, :option_price => 6.00)).should === 6.7
      iv_pct(@call_opts.merge(:option_strike => 1560.00, :option_price => 3.70)).should === 7.5
      iv_pct(@call_opts.merge(:option_strike => 1565.00, :option_price => 2.00)).should === 7.8
    end
  end
  
  describe "put options" do
    before(:all) {
      @put_opts = @opts.merge(:option_type => :put)
    }
    
    it "should take 0.0005s per calculation" do
      test_speed(0.0005) { iv_pct(@put_opts) }
    end

    it "should calculate the iv" do
      iv_pct(@put_opts.merge(:option_strike =>  800.00, :option_price => 0.00)).should be_nil
      iv_pct(@put_opts.merge(:option_strike => 1555.00, :option_price => 8.00)).should === 17.4
      iv_pct(@put_opts.merge(:option_strike => 1560.00, :option_price => 10.40)).should === 17.4
      iv_pct(@put_opts.merge(:option_strike => 1565.00, :option_price => 13.60)).should === 18.1
    end
  end
end
