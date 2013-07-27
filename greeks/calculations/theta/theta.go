//
// Theta
//
// The change in an option's value that an investor can expect from the passage of one day, assuming nothing else changes.
//
// Theta can be calculated in two ways, as the dollar change of the option that an investor can expect for a one-day passage of time,
// all else remaining equal, or as a percentage change in the option price for a one-day passage of time, all else remaining equal.
// For example, if an option trades at $1 on Monday morning and it has a theta of -$0.10 per day, you can expect the option to trade
// at $0.90 on Tuesday morning. Another way of measuring theta for that option is ($0.90 - $1)/$1 or -10% per day.

package theta

import "math"
import . "../contract"

type ThetaOpts struct {
	OptionType               OptionsContractType "option contract type"
	DividendRate             float64             "Stock Dividend Rate"
	FedRate                  float64             "Federal Reserve Interest Rate"
	OptionExpiresYearPctSqrt float64             "Square-Root of Option Expires in Year Percentage"
	PriceVsRateVsExpires     float64             "Stock Price vs Stock Dividend Rate vs Option Expires In Year Percentage"
	StrikeVsRateVsExpires    float64             "Option Strike vs Stock Dividend Rate vs Option Expires In Year Percentage"
	IV                       float64             "Implied Volatility"
	ND1                      float64             "???"
	D1NormalDistribution     float64             "First Derivative Normal Distribution"
	D2NormalDistribution     float64             "Second Derivative Normal Distribution"
}

func Theta(opts *ThetaOpts) float64 {
	if math.IsNaN(opts.IV) {
		return math.NaN()
	}

	part0 := opts.PriceVsRateVsExpires * opts.ND1 * opts.IV
	part1 := 2 * opts.OptionExpiresYearPctSqrt
	part2 := opts.DividendRate * opts.PriceVsRateVsExpires * opts.D1NormalDistribution
	part3 := opts.FedRate * opts.StrikeVsRateVsExpires * opts.D2NormalDistribution

	prefix0 := -part0 / part1

	if IsCallContract(opts.OptionType) {
		return (prefix0 + part2 - part3) / 365
	} else {
		return (prefix0 - part2 + part3) / 365
	}
}
