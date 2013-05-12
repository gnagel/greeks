require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  include Math::GreekCalculationHelpers


  let(:federal_reserve_interest_rate) { 0.0 }
  let(:federal_reserve_interest_rate_f) { federal_reserve_interest_rate / 100.0 }
  let(:stock_dividend_rate) { 0.0 }
  let(:stock_dividend_rate_f) { stock_dividend_rate / 100 }
  let(:stock_price) { 1558.86 }
  let(:option_expires_in_days) { 2.0 }
  let(:option_expires_pct_year) { (option_expires_in_days + 1.0) / 365.0 }

  describe "call options" do
    let(:option_type) { :call }

    context "should calculate the iv" do
      let(:option_strike) {  800.00 }
      let(:option_price) { 751.50 } 
      it { var_iv().should be_nil }
    end

    context "should calculate the iv" do
      let(:option_strike) { 1555.00 }
      let(:option_price) {   6.00 } 
      it { var_iv().round(4).should === 0.0668 }
    end

    context "should calculate the iv" do
      let(:option_strike) { 1560.00 }
      let(:option_price) {   3.70 } 
      it { var_iv().round(4).should === 0.0753 }
    end

    context "should calculate the iv" do
      let(:option_strike) { 1565.00 }
      let(:option_price) {   2.00 } 
      it { var_iv().round(4).should === 0.0780 }
    end
  end
  
  describe "put options" do
    let(:option_type) { :put }

    context "should calculate the iv" do
      let(:option_strike) {  800.00 }
      let(:option_price) { 751.50 } 
      it { var_iv().should be_nil }
    end

    context "should calculate the iv" do
      let(:option_strike) { 1555.00 }
      let(:option_price) {   8.00 } 
      it { var_iv().round(4).should === 0.1742 }
    end

    context "should calculate the iv" do
      let(:option_strike) { 1560.00 }
      let(:option_price) {   10.40 } 
      it { var_iv().round(4).should === 0.1741 }
    end

    context "should calculate the iv" do
      let(:option_strike) { 1565.00 }
      let(:option_price) {   13.60 } 
      it { var_iv().round(4).should === 0.1812 }
    end
  end
end
