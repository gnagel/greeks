require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv_price_vs_rate_vs_expires" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:option_expires_pct_year) { 1.00 }
  let(:stock_dividend_rate_f) { 0.05 }
  let(:expected) { 9.51229424500714 }
  subject { iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f) }
  
  it { should === expected }
end
