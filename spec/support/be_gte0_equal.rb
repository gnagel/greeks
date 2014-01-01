require 'rspec'
require 'rspec-expectations'

RSpec::Matchers.define :be_gte0_equal do |expected|
  match do |actual|
    if expected.zero? || expected.nil?
      actual.should be_zero
    else
      actual.to_i.should > 0
      actual.should be_rounded_equal expected
    end
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would be close to #{expected} at 2x decimal places"
  end
end