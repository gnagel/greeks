//
// Chance of Breakeven
//
// The probability that a stock will be trading beyond the breakeven price as implied by the option price.
//
// Chance of Breakeven can be used to get a sense for the valuation of the option by comparing the markets'
// estimate of Chance of Breakeven to estimates derived from your own fundamental research.
// If you believe the Chance of Breakeven is less than the probability that a stock will be beyond the
// breakeven price at option expiration, then you believe the option is undervalued, and visa versa.

package greeks

import "math"

type ChanceOfBreakEvenOpts struct {
	DividendRate             float64             "Stock Dividend Rate"
	FedRate                  float64             "Federal Reserve Interest Rate"
	StockPrice               float64             "Stock Price"
	OptionType               OptionsContractType "option contract type"
	OptionPrice              float64             "Target Price of the Option Contract"
	StrikePrice              float64             "Strike Price of the Option Contract"
	OptionExpiresYearPct     float64             "Option Expires in Year Percentage"
	OptionExpiresYearPctSqrt float64             "Square-Root of Option Expires in Year Percentage"
	IV                       float64             "Implied Volatility"
}

func ChanceOfBreakEven(opts *ChanceOfBreakEvenOpts) float64 {
	if math.IsNaN(opts.IV) || math.IsNaN(opts.OptionPrice) || opts.OptionPrice < 0 {
		return math.NaN()
	}

	part1 := (opts.FedRate - opts.DividendRate - opts.IV*opts.IV/2) * opts.OptionExpiresYearPct
	part2 := opts.IV * opts.OptionExpiresYearPctSqrt

	multiplier := OptionTypeMultiplier(opts.OptionType)

	part3 := (opts.StrikePrice + multiplier*opts.OptionPrice)
	part4 := math.Log(opts.StockPrice / part3)

	return NormalDistribution(multiplier * (part4 + part1) / part2)
}
