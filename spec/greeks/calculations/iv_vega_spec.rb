require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv_vega" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate_f) { 0.00 }
  let(:option_expires_pct_year) { 1.00 }
  let(:volatility_guess) { 0.50 }

  def var_du
    iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
  end

  def var_price_vs_rate_vs_expires
    iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f)
  end
  
  def var_vega
    iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)
  end
  
  context "exactly at the money" do
    let(:option_strike) { 10.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 3.866681168028493 }
      
      it { var_vega().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 3.866294209940902 }
      
      it { var_vega().should === expected }
    end
  end
  
  context "out of the money" do
    let(:option_strike) { 15.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 3.4086802947730774 }
      
      it { var_vega().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 3.4094449205351056 }
      
      it { var_vega().should === expected }
    end
  end
  
  context "in of the money" do
    let(:option_strike) { 5.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 1.045940982192684 }
      
      it { var_vega().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 1.045256535627944 }
      
      it { var_vega().should === expected }
    end
  end
end
