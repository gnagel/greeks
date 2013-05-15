require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::gamma" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations
  
  it { gamma(:stock_price => 1.0, :option_expires_pct_year_sqrt => 2.0, :iv => 3.0, :nd1 => 4.0, :rate_vs_expires => 5.0).round(2).should. === 3.33 }
end
