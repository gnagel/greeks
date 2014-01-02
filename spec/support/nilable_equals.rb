require 'rspec'
require 'rspec-expectations'

RSpec::Matchers.define :nilable_equals do |expected, decimal_places|
  match do |actual|
    if expected.nil? || expected.zero?
      actual.should be_nil
    else
      actual.should strict_equals expected, decimal_places
    end
  end

  failure_message_for_should do |actual|
    "expected that '#{actual}' would match of '#{expected}' to within '#{decimal_places}' decimal places"
  end
end