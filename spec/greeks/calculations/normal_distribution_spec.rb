require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::normal_distribution" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations

  it "should take 0.000005s per calculation" do
    test_speed(0.000005) { normal_distribution(0.0) }
  end

  it "should calculate the normal_distribution" do
    normal_distribution(-0.0).should === 0.5000000005248086
    normal_distribution(0.038237059844021946).should === 0.5152507249371991
    normal_distribution(0.038410221197121876).should === 0.5153197557441735
    normal_distribution(0.05419795049563356).should === 0.5216113427954938
    normal_distribution(0.08866836079942457).should === 0.5353273260368764
    normal_distribution(0.22705303864277918).should === 0.5898087102891723
    normal_distribution(0.23102722425730948).should === 0.5913531319833535
    normal_distribution(0.24375225242810844).should === 0.5962886004762329
    normal_distribution(0.24745839358343474).should === 0.5977232060736917
  end
end
