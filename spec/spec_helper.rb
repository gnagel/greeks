require 'rubygems'

require 'rspec'
require 'rspec-expectations'
require 'benchmark'

$:.push File.expand_path("../lib", File.dirname(__FILE__))
require 'greeks'

$spec_root = File.dirname(__FILE__)

RSpec.configure do |config|
  old_verbose, $VERBOSE = $VERBOSE, nil
  
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
