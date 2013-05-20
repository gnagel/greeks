require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::rho" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  let(:opts) { {:option_expires_pct_year => 1.0, :strike_vs_fed_vs_expires => 2.0, :d2_normal_distribution => 3.0} }

  ##
  # General behavior tests
  ##
  it { expect{ rho(opts) }.to raise_error ArgumentError }

  it { rho(opts.merge(:option_type => :call, :iv => nil)).should be_nil }
  it { rho(opts.merge(:option_type => :put,  :iv => nil)).should be_nil }

  it { rho(opts.merge(:option_type => :call, :iv => 'any value')).should ===  0.06 }
  it { rho(opts.merge(:option_type => :put,  :iv => 'any value')).should ===  -0.06 }

  ##
  # More specific examples
  ##
  # TODO
end
