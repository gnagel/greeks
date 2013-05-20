greeks
======

Calculate greeks for options trading (Implied Volatility, Delta, Gamma, Vega, Rho, and Theta)


Examples
========
What are the Greeks for Calls & Puts for AMD ($4.07 @ 35days)?

AMD stock      = $4.07
Option Strike  = $4.50
Option Expires = 35 days

Fed Rate       = 0.01%
Dividend Rate  = 0%

Call Bid       = $0.16
Put Bid        = $0.59

```ruby
# Calculate the Greeks for the Stock & Option Contract
calc = Math::Greeks::Calculator.new(
	:stock_price                   => 4.07,
	:stock_dividend_rate           => 0.00,
	:federal_reserve_interest_rate => 0.01,
	:option_expires_in_days        => 35.0,
	:option_strike                 => 4.50,
	:option_type                   => :call,
	:option_price                  => 0.16,
)

# What are the display values?
hash = calc.to_hash # Convert the values for display/consumption
hash[:iv]         # => 61.93 (Implied Volatility %)
hash[:delta]      # => -4.57 (Delta %/%)
hash[:gamma]      # => -2.84 (Gamma pp/pp)
hash[:vega]       # =>  0.49 (Vega %/pp)
hash[:rho]        # => -0.55 (Rho %/pp)
hash[:theta]      # => -0.68 (Theta %/day)
hash[:break_even] # => 45.66 (Chance of Breakeven)

# What are the raw values?
calc.break_even # What is the raw Break Even odds (0.000 to 1.000)
calc.iv         # What is the raw IV value (0.000 to 1.000)
calc.delta      # What is the raw Delta $/$?
calc.gamma      # What is the raw Gamma $/$?
calc.vega       # What is the raw Vega $/pp?
calc.rho        # What is the raw Rho $/pp?
calc.theta      # What is the raw Theta $/day?
```
