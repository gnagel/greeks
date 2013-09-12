require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::misc_price_ratio_log_less_rates" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate_f) { 0.00 }
  let(:option_expires_pct_year) { 1.00 }
  
  it "Break Even Call" do
    value = break_even({:option_type => :call, :option_expires_pct_year => 1.0, :option_expires_pct_year_sqrt => 1.0, :option_price => 2.0, :option_strike => 3.0, :stock_price => 4.0, :stock_dividend_rate_f => 5.0, :federal_reserve_interest_rate_f => 6.0, :iv => 7.0})
    value.round(5).should === 0.000350766161827831.round(5)
  end
  
  it "Break Even Put" do 
    value = break_even({:option_type => :put, :option_expires_pct_year => 1.0, :option_expires_pct_year_sqrt => 1.0, :option_price => 2.0, :option_strike => 3.0, :stock_price => 4.0, :stock_dividend_rate_f => 5.0, :federal_reserve_interest_rate_f => 6.0, :iv => 7.0})
    value.round(5).should === 0.999208650294576.round(5)
  end

  context "exactly at the money" do
    let(:option_strike) { 10.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 0.00 }

      it { var_price_ratio_log_less_rates().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 0.0002 }

      it { var_price_ratio_log_less_rates().should === expected }
    end
  end
  
  context "out of the money" do
    let(:option_strike) { 15.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { -0.40546510810816444 }

      it { var_price_ratio_log_less_rates().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { -0.40526510810816446 }

      it { var_price_ratio_log_less_rates().should === expected }
    end
  end
  
  context "in of the money" do
    let(:option_strike) { 5.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 0.6931471805599453 }

      it { var_price_ratio_log_less_rates().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 0.6933471805599453 }

      it { var_price_ratio_log_less_rates().should === expected }
    end
  end
end


describe "Math::GreekCalculations::misc_price_vs_rate_vs_expires" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:option_expires_pct_year) { 1.00 }
  let(:stock_dividend_rate_f) { 0.05 }
  let(:expected) { 9.51229424500714 }
  subject { misc_price_vs_rate_vs_expires(:stock_price => stock_price, :option_expires_pct_year => option_expires_pct_year, :stock_dividend_rate_f => stock_dividend_rate_f) }
  
  it { should === expected }
end