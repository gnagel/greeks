require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::rho" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  it { rho(:option_type => :call, :option_expires_pct_year => 1.0, :strike_vs_fed_vs_expires => 2.0, :d2_normal_distribution => 3.0, :iv => 'any value').should ===  0.06 }
  it { rho(:option_type => :put,  :option_expires_pct_year => 1.0, :strike_vs_fed_vs_expires => 2.0, :d2_normal_distribution => 3.0, :iv => 'any value').should === -0.06 }
end
