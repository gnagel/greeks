require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::vega" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  let(:opts) { {:price_vs_rate_vs_expires =>  1.0, :nd1 =>  1.0, :option_expires_pct_year_sqrt => 1.0} }

  ##
  # General behavior tests
  ##
  it { expect{ vega(opts) }.to raise_error ArgumentError }

  it { vega(opts.merge(:iv => nil)).should be_nil }

  it { vega(opts.merge(:iv => 'any value')).round(2).should === 0.01 }

  ##
  # More specific examples
  ##
  it { vega(:price_vs_rate_vs_expires =>  1.0, :nd1 =>  1.0, :option_expires_pct_year_sqrt => 1.0, :iv => 'any value').should === 0.01 }
  it { vega(:price_vs_rate_vs_expires =>  3.0, :nd1 =>  2.0, :option_expires_pct_year_sqrt => 1.0, :iv => 'any value').should === 0.06 }
  it { vega(:price_vs_rate_vs_expires => 10.0, :nd1 => 10.0, :option_expires_pct_year_sqrt => 5.0, :iv => 'any value').should === 5.0 }
end
