require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::delta" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  it { delta(:option_type => :call, :rate_vs_expires => 1.0, :d1_normal_distribution => 1.0, :iv => 'any value').should === 1.0 }
  it { delta(:option_type => :put,  :rate_vs_expires => 1.0, :d1_normal_distribution => 1.0, :iv => 'any value').should === -1.0 }
end
