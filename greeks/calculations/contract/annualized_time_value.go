//
// Annualized Time Value
//
// The time value of the option divided by the strike price, then annualized.
//
// You can use annualized time value to develop an intuitive understanding of how much value the option market is adding to
// an in-the-money option beyond the intrinsic value. For example, if a stock is trading at $40 and a
// six month call on that stock with a strike price of $35 has an intrinsic value of $5 and a total
// value of $7, the time value ($2) divided by the strike is ($2/$40) = 5%. Annualizing that time value
// to a one year horizon on a continuously compounded basis yields 9.76% (2 × ln(1 + 0.05)).

package greeks

import "math"

type AnnualizedTimeValueOpts struct {
	StockPrice, OptionExpiresYearPct, TimeValue float64
}

func AnnualizedTimeValue(opts *AnnualizedTimeValueOpts) float64 {
	if math.IsNaN(opts.TimeValue) {
		return math.NaN()
	}

	c := 100 * math.Log(1.0+opts.TimeValue/opts.StockPrice) / opts.OptionExpiresYearPct
	return NanOrGte0(c)
}
