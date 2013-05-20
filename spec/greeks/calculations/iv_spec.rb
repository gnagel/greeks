require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  include Math::GreekCalculationHelpers

  ##
  # General behavior tests
  ##
  it { opts = {:a => :b}; expect { iv(opts) }.to raise_error ArgumentError, "Missing keys=option_price in opts={:a=>:b}" }

  it { iv(:option_price => nil).should be_nil }

  it { 
    iv(
      :federal_reserve_interest_rate_f => 0.0, 
      :stock_price                     => 10.00, 
      :stock_dividend_rate_f           => 0.0, 
      :option_type                     => :call, 
      :option_price                    => 1.0,
      :option_strike                   => 10.00, 
      :option_expires_pct_year         => 1.0, 
      :option_expires_pct_year_sqrt    => 1.0, 
      :rate_vs_expires                 => 1.0,
      :price_vs_rate_vs_expires        => 1.0,
      :strike_vs_fed_vs_expires        => 1.0,
      :price_ratio_log_less_rates      => 1.0,
      ).should === 21453795590575736000000.0
  }

  it { 
    iv(
      :federal_reserve_interest_rate_f => 0.0, 
      :stock_price                     => 10.00, 
      :stock_dividend_rate_f           => 0.0, 
      :option_type                     => :put, 
      :option_price                    => 1.0,
      :option_strike                   => 10.00, 
      :option_expires_pct_year         => 1.0, 
      :option_expires_pct_year_sqrt    => 1.0, 
      :rate_vs_expires                 => 1.0,
      :price_vs_rate_vs_expires        => 1.0,
      :strike_vs_fed_vs_expires        => 1.0,
      :price_ratio_log_less_rates      => 1.0,
      ).should === 21453795590575736000000.0
  }


  ##
  # More specific examples
  ##
  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate) { 0.0 }
  let(:stock_dividend_rate_f) { 0.0 }

  let(:option_strike) { 10.00 }
  let(:option_price) { 1.00 } 
  let(:option_expires_in_days) { 364.0 }
  let(:option_expires_pct_year) { 1.0 }

  let(:federal_reserve_interest_rate) { 0.0 }
  let(:federal_reserve_interest_rate_f) { 0.00 }

  describe "call options" do
    let(:option_type) { :call }
    
    context "exactly at the money" do
      let(:option_strike) { 10.00 }
      it { var_iv().should === 0.25089263455361754 }
    end
    
    context "out of the money" do
      let(:option_strike) { 15.00 }
      it { var_iv().should === 0.5819996182323802 }
    end
    
    context "in the money" do
      let(:option_strike) { 5.00 }
      it { var_iv().should === nil }
    end
  end
  
  describe "put options" do
    let(:option_type) { :put }

    context "exactly at the money" do
      let(:option_strike) { 10.00 }
      it { var_iv().should === 0.25089263455361754 }
    end
    
    context "out of the money" do
      let(:option_strike) { 15.00 }
      it { var_iv().should === nil }
    end
    
    context "in the money" do
      let(:option_strike) { 5.00 }
      it { var_iv().should === 1.0245859277769118 }
    end
  end
end
