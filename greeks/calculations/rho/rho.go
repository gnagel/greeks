//
// Rho
//
// The change in the value of an option for a change in the prevailing interest rate that matches the duration of the option, all else held equal.

// Generally rho is not a big driver of price changes for options, as interest rates tend to be relatively stable.

package rho

import "math"
import . "../contract"

type RhoOpts struct {
	OptionType            OptionsContractType "option contract type"
	OptionExpiresYearPct  float64             "Option Expires in Year Percentage"
	StrikeVsRateVsExpires float64             "Option Strike vs Stock Dividend Rate vs Option Expires In Year Percentage"
	D2NormalDistribution  float64             "Second Derivative Normal Distribution"
}

func Rho(opts *RhoOpts) float64 {
	if math.IsNaN(opts.D2NormalDistribution) {
		return math.NaN()
	}

	multiplier := OptionTypeMultiplier(opts.OptionType)
	return multiplier * opts.OptionExpiresYearPct * opts.StrikeVsRateVsExpires * opts.D2NormalDistribution / 100
}
