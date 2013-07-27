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

import (
	"github.com/orfjackal/gospec/src/gospec"
	. "github.com/orfjackal/gospec/src/gospec"
	"math"
)

// Helpers
func ChanceOfBreakEvenSpec(c gospec.Context) {
	c.Specify("IV=NaN, returns NaN", func() {
		opts := &ChanceOfBreakEvenOpts{OptionType: OptionsCallContract, OptionExpiresYearPct: 1.0, OptionExpiresYearPctSqrt: 1.0, OptionPrice: 2.0, StrikePrice: 3.0, StockPrice: 4.0, DividendRate: 5.0, FedRate: 6.0, IV: math.NaN()}
		actual := ChanceOfBreakEven(opts)
		c.Expect(actual, Satisfies, math.IsNaN(actual))
	})

	c.Specify("Call Contract", func() {
		opts := &ChanceOfBreakEvenOpts{OptionType: OptionsCallContract, OptionExpiresYearPct: 1.0, OptionExpiresYearPctSqrt: 1.0, OptionPrice: 2.0, StrikePrice: 3.0, StockPrice: 4.0, DividendRate: 5.0, FedRate: 6.0, IV: 7.0}
		actual := ChanceOfBreakEven(opts)
		c.Expect(actual, Equals, float64(0.00035076616182783127))
	})

	c.Specify("Put Contract", func() {
		opts := &ChanceOfBreakEvenOpts{OptionType: OptionsPutContract, OptionExpiresYearPct: 1.0, OptionExpiresYearPctSqrt: 1.0, OptionPrice: 2.0, StrikePrice: 3.0, StockPrice: 4.0, DividendRate: 5.0, FedRate: 6.0, IV: 7.0}
		actual := ChanceOfBreakEven(opts)
		c.Expect(actual, Equals, float64(0.999208650294576))
	})
}
