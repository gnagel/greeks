require 'rspec'
require 'rspec-expectations'

RSpec::Matchers.define :be_a_greeks_hash do |expected|
  match do |actual|
    hash = actual.to_hash
    hash.should_not be_nil
    hash.should_not be_empty
    
    keys = [hash.keys, expected.keys].flatten.uniq.sort
    verbose_puts "Keys: #{keys.inspect}"
    keys.each do |key|
      verbose_puts "[#{"%30s" % key}] Hash: #{hash[key].inspect} vs Actual: #{expected[key].inspect}"
    end

    # Delete all the values that match
    # This will leave only the values that differ
    expected.keys.dup.each do |key|
      expected.delete(key) if hash[key] == expected[key]
    end
    verbose_puts "Hash: #{hash}"
    verbose_puts "Expected: #{expected}"
    expected.should be_empty
  end

  failure_message_for_should do |actual|
    "expected that #{actual.to_hash} would match values of #{expected}"
  end
end