require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::delta" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  let(:opts) { {:rate_vs_expires => 1.0, :d1_normal_distribution => 1.0} }

  ##
  # General behavior tests
  ##
  it { expect{ delta(opts) }.to raise_error ArgumentError }

  it { delta(opts.merge(:option_type => :call, :iv => nil)).should be_nil }
  it { delta(opts.merge(:option_type => :put,  :iv => nil)).should be_nil }

  it { delta(opts.merge(:option_type => :call, :iv => 'any value')).should === 1.0 }
  it { delta(opts.merge(:option_type => :put,  :iv => 'any value')).should === -1.0 }

  ##
  # More specific examples
  ##
  # TODO
end
