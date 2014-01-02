# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "greeks"
  gem.version       = '1.4'
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

  gem.add_dependency('require_all')
  gem.add_dependency('hash_plus', '>= 1.3')
end
