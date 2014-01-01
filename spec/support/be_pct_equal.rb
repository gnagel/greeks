require 'rspec'
require 'rspec-expectations'

RSpec::Matchers.define :be_pct_equal do |expected|
  match do |actual|
    actual.should be_rounded_equal (expected / 100.0)
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would be close to #{expected} at 2x decimal places"
  end
end