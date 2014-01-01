require 'rspec'
require 'rspec-expectations'

RSpec::Matchers.define :be_rounded_equal do |expected|
  match do |actual|
    if expected.zero?
      actual.should be_nil
    else
      actual.round(2) == expected.round(2)
    end
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would be close to #{expected} at 2x decimal places"
  end
end