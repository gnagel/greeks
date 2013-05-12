require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  include Math::GreekCalculationHelpers

  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate) { 0.0 }
  let(:stock_dividend_rate_f) { 0.0 }

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
