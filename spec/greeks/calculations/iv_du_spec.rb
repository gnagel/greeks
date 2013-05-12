require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv_du" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate_f) { 0.00 }
  let(:option_expires_pct_year) { 1.00 }
  
  def var_du
    iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
  end
  
  context "exactly at the money" do
    let(:option_strike) { 10.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 0.00 }

      it { var_du().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 0.0002 }

      it { var_du().should === expected }
    end
  end
  
  context "out of the money" do
    let(:option_strike) { 15.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { -0.40546510810816444 }

      it { var_du().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { -0.40526510810816446 }

      it { var_du().should === expected }
    end
  end
  
  context "in of the money" do
    let(:option_strike) { 5.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 0.6931471805599453 }

      it { var_du().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 0.6933471805599453 }

      it { var_du().should === expected }
    end
  end
end
