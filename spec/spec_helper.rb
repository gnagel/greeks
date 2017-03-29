$:.push File.expand_path("../lib", File.dirname(__FILE__))
require 'rubygems'
require 'greeks'

require 'rspec'
# require 'rspec-expectations'
require 'benchmark'
require 'require_all'
require 'csv'
# require 'rantly/property'
# require 'rantly/rspec_extensions'
require 'pry'
require 'pry-nav'

$spec_root = File.dirname(__FILE__)

require_all File.join($spec_root, 'support')
require_all File.join($spec_root, 'helpers')

RSpec.configure do |config|
  config.include Math::GreekCalculationShorthandHelpers

  old_verbose, $VERBOSE = $VERBOSE, nil

  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }
  
  def verbose_puts(s)
    return unless $VERBOSE
    file = File.basename(caller(1).first)
    super("puts() from #{file}: #{s}")
  end
  
  def puts(s)
    file = File.basename(caller(1).first)
    super("puts() from #{file}: #{s}")
  end
  
  def print(s)
    file = File.basename(caller(1).first)
    super("print() from #{file}: #{s}")
  end

  def p(s)
    file = File.basename(caller(1).first)
    super("p() from #{file}: #{s}")
  end
  
  def test_speed(x_speed, x_times = 1000)
    time = Benchmark.realtime { x_times.times { |n| @result = yield } }
    (time / x_times).should < x_speed
    @result
  end
end
