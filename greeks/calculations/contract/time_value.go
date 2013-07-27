//
// Time Value
//
// The value of an option that captures the chance of further appreciation before expiration.
//
// The value of an option can be broken down into intrinsic value, or the value of the option
// if it were exercised today, and time value, or the added value of the option over and above
// the intrinsic value. For example, if a stock is trading at $40 and a call with a strike price
// of $35 were trading for $7, the call would have a $5 intrinsic value ($40-$35) and a $2 time value ($7-$5).
// Time value will decay by expiration assuming the underlying security stays at the same price.

package greeks

import "math"

type TimeValueOpts struct {
	OptionPrice, PremiumValue float64
}

func TimeValue(opts *TimeValueOpts) float64 {
	if math.IsNaN(opts.PremiumValue) {
		return math.NaN()
	}

	c := opts.OptionPrice - opts.PremiumValue
	return NanOrGte0(c)
}
