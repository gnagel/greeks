# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "greeks/version"

Gem::Specification.new do |gem|
  gem.name          = "greeks"
  gem.version       = Math::Greeks::VERSION
  gem.authors       = ["Glenn Nagel"]
  gem.email         = ["glenn@mercury-wireless.com"]
  gem.homepage      = "https://github.com/gnagel/greeks"
  gem.summary       = %q{Calculate greeks for options trading (Implied Volatility, Delta, Gamma, Vega, Rho, and Theta)}
  gem.description   = %q{Calculate greeks (iv, delta, gamma, vega, rho, theta)}
  gem.license       = 'MIT'
  

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "tasks"]

  # System
  gem.add_dependency('require_all')
  gem.add_dependency('hash_plus', '>= 1.3')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rspec-expectations')
end
