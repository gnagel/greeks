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

import (
	"github.com/orfjackal/gospec/src/gospec"
	. "github.com/orfjackal/gospec/src/gospec"
	"math"
)

// Helpers
func AnnualizedTimeValueSpec(c gospec.Context) {
	c.Specify("TimeValue=NaN returns NaN", func() {
		opts := &AnnualizedTimeValueOpts{StockPrice: 1.0, OptionExpiresYearPct: 2.0, TimeValue: math.NaN()}
		actual := AnnualizedTimeValue(opts)
		c.Expect(actual, Satisfies, math.IsNaN(actual))
	})

	c.Specify("Calculates AnnualizedTimeValue", func() {
		opts := &AnnualizedTimeValueOpts{StockPrice: 1.0, OptionExpiresYearPct: 2.0, TimeValue: 3.0}
		actual := AnnualizedTimeValue(opts)
		c.Expect(actual, Equals, float64(69.31471805599453))
	})

	// For example, if a stock is trading at $40 and a six month call on that stock with a strike price of $35
	// has an intrinsic value of $5 and a total value of $7,
	// the time value ($2) divided by the strike is ($2/$40) = 5%.
	// Annualizing that time value to a one year horizon on a continuously compounded basis yields 9.76% (2 × ln(1 + 0.05)).
	c.Specify("Calculates AnnualizedTimeValue", func() {
		opts := &AnnualizedTimeValueOpts{StockPrice: 40, OptionExpiresYearPct: 0.5, TimeValue: 2.0}
		actual := AnnualizedTimeValue(opts)
		c.Expect(actual, Equals, float64(9.75803283388641))
	})

}
