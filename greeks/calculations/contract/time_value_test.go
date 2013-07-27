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

import (
	"github.com/orfjackal/gospec/src/gospec"
	. "github.com/orfjackal/gospec/src/gospec"
	"math"
)

// Helpers
func TimeValueSpec(c gospec.Context) {
	c.Specify("TimeValue=NaN returns NaN", func() {
		opts := &TimeValueOpts{OptionPrice: 1.0, PremiumValue: math.NaN()}
		actual := TimeValue(opts)
		c.Expect(actual, Satisfies, math.IsNaN(actual))
	})

	// For example, if a stock is trading at $40 and a call with a strike price of $35 were trading for $7,
	// the call would have a $5 intrinsic value ($40-$35) and a $2 time value ($7-$5).
	c.Specify("Calculates TimeValue", func() {
		opts := &TimeValueOpts{OptionPrice: 7, PremiumValue: 5}
		actual := TimeValue(opts)
		c.Expect(actual, Equals, float64(2))
	})
}
