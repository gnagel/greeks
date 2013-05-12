require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::vega" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  it { vega(:price_vs_rate_vs_expires =>  1.0, :nd1 =>  1.0, :option_expires_pct_year_sqrt => 1.0).should === 0.01 }
  it { vega(:price_vs_rate_vs_expires =>  3.0, :nd1 =>  2.0, :option_expires_pct_year_sqrt => 1.0).should === 0.06 }
  it { vega(:price_vs_rate_vs_expires => 10.0, :nd1 => 10.0, :option_expires_pct_year_sqrt => 5.0).should === 5.0 }
end
