//
// Vega
//
// The change in the price of an option for a change in the implied volatility of the option, all else held equal.
//
// In general, as the options market thinks it is more difficult to value a stock, implied volatility and therefore
// the price of the options will increase. For example, if an option is trading for $1, the implied volatility is 20%,
// and the vega is $0.05, then a one-percentage-point increase in implied volatility to 21% would correspond to an increase in
// the price of the option to $1.05. In percentage terms, the vega in this case would be ($0.05/$1.00)/(1 percentage point) = 5%.

package vega

import "math"

type VegaOpts struct {
	PriceVsRateVsExpires     float64 "Stock Price vs Stock Dividend Rate vs Option Expires In Year Percentage"
	OptionExpiresYearPctSqrt float64 "Square-Root of Option Expires in Year Percentage"
	ND1                      float64 "???"
}

func Vega(opts *VegaOpts) float64 {
	if math.IsNaN(opts.ND1) {
		return math.NaN()
	}

	return opts.PriceVsRateVsExpires * opts.OptionExpiresYearPctSqrt * opts.ND1 / 100
}
