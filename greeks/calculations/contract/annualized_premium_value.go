//
// Annualized Premium
//
// The annualized premium is the value of the option divided by the strike price.
//
// You can use annualized premium to develop an intuitive understanding of how much the market is "paying" for a dollar of risk.
// For example, if a stock is trading at $50 and you sell a $50 strike 6 month call for $4, you are getting
// paid 8% in 6 months, or about 16% annualized, in exchange for being willing to buy at $50, the current price.

package greeks

import "math"

type AnnualizedPremiumValueOpts struct {
	OptionPrice, StrikePrice, OptionExpiresYearPct float64
}

func AnnualizedPremiumValue(opts *AnnualizedPremiumValueOpts) float64 {
	if math.IsNaN(opts.OptionPrice) || opts.OptionPrice < 0 {
		return math.NaN()
	}

	c := 100 * math.Log(1+opts.OptionPrice/opts.StrikePrice) / opts.OptionExpiresYearPct
	return NanOrGte0(c)
}
