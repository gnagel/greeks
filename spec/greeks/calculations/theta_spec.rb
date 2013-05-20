require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::theta" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  let(:opts) { {:option_type => :call, :stock_dividend_rate_f => 0.00, :federal_reserve_interest_rate_f => 0.00, :option_expires_pct_year_sqrt => 1.0, :strike_vs_fed_vs_expires => 1.0, :price_vs_rate_vs_expires => 1.0, :nd1 => 1.0, :d1_normal_distribution => 1.0, :d2_normal_distribution => 1.0} }

  ##
  # General behavior tests
  ##
  it { expect{ theta(opts) }.to raise_error ArgumentError }

  it { theta(opts.merge(:iv => nil)).should be_nil }

  it { theta(opts.merge(:iv => 1.0)).round(2).should. === 0.0 }

  ##
  # More specific examples
  ##
  it { theta(:option_type => :call, :stock_dividend_rate_f => 1.0005, :federal_reserve_interest_rate_f => 2.0002, :option_expires_pct_year_sqrt => 1.0, :iv => 1.0, :strike_vs_fed_vs_expires => 3.0, :price_vs_rate_vs_expires => 4.0, :nd1 => 5.0, :d1_normal_distribution => 6.0, :d2_normal_distribution => 7.0).should === -0.0766909589041096 }
  
  it { theta(:option_type => :put,  :stock_dividend_rate_f => 1.0005, :federal_reserve_interest_rate_f => 2.0002, :option_expires_pct_year_sqrt => 1.0, :iv => 1.0, :strike_vs_fed_vs_expires => 3.0, :price_vs_rate_vs_expires => 4.0, :nd1 => 5.0, :d1_normal_distribution => 6.0, :d2_normal_distribution => 7.0).should === 0.021896438356164394 }
end
