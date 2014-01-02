require 'rspec'
require 'rspec-expectations'

RSpec::Matchers.define :strict_equals do |expected, decimal_places|
  match do |actual|
    FormatFloat(actual, decimal_places).should == expected
  end

  failure_message_for_should do |actual|
    "expected that '#{actual}' would match of '#{expected}' to within '#{decimal_places}' decimal places"
  end
end