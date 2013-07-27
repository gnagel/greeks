//
// Intrinsic Value
//
// The value that the option would pay if it were executed today.
//
// For example, if a stock is trading at $40, a call on that stock with a strike price of $35
// would have $5 of intrinsic value ($40-$35) if it were  exercised today. However, the call
// should actually be worth more than $5 to account for the value of the  chance of any further
// appreciation until expiration, and the difference between the price and the intrinsic value
// would be the time value.

package greeks

import "github.com/orfjackal/gospec/src/gospec"
import . "github.com/orfjackal/gospec/src/gospec"

// Helpers
func IntrinsicValueSpec(c gospec.Context) {
	// For example, if a stock is trading at $40, a call on that stock with a strike price of $35
	// would have $5 of intrinsic value ($40-$35) if it were  exercised today.
	c.Specify("Calculates IntrinsicValue", func() {
		opts := &IntrinsicValueOpts{OptionType: OptionsCallContract, StockPrice: 40, StrikePrice: 35}
		actual := IntrinsicValue(opts)
		c.Expect(actual, Equals, float64(5))
	})
}
