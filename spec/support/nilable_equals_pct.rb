require 'rspec'

RSpec::Matchers.define :nilable_equals_pct do |expected, decimal_places|
  match do |actual|
    if expected.nil? || expected.zero?
      actual.should be_nil
    else
      actual.should strict_equals_pct expected, decimal_places
    end
  end

  failure_message do |actual|
    "expected that '#{actual}' would match of '#{expected}' to within '#{decimal_places}' decimal places"
  end
end