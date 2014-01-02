require 'rspec'
require 'rspec-expectations'

RSpec::Matchers.define :strict_equals_pct do |expected, decimal_places|
  match do |actual|
    FormatFloat(actual.to_f * 100.0, decimal_places).should == expected
  end

  failure_message_for_should do |actual|
    "expected that '#{actual}' would match of '#{expected}' to within '#{decimal_places}' decimal places"
  end
end