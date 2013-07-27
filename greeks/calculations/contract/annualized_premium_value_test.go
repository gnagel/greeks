//
// Annualized Premium
//
// The annualized premium is the value of the option divided by the strike price.
//
// You can use annualized premium to develop an intuitive understanding of how much the market is "paying" for a dollar of risk.
// For example, if a stock is trading at $50 and you sell a $50 strike 6 month call for $4, you are getting
// paid 8% in 6 months, or about 16% annualized, in exchange for being willing to buy at $50, the current price.

package greeks

import (
	"github.com/orfjackal/gospec/src/gospec"
	. "github.com/orfjackal/gospec/src/gospec"
	"math"
)

// Helpers
func AnnualizedPremiumValueSpec(c gospec.Context) {
	c.Specify("OptionPrice=NaN returns NaN", func() {
		opts := &AnnualizedPremiumValueOpts{OptionPrice: math.NaN(), StrikePrice: 50, OptionExpiresYearPct: 0.5}
		actual := AnnualizedPremiumValue(opts)
		c.Expect(actual, Satisfies, math.IsNaN(actual))
	})

	c.Specify("OptionPrice<0 returns NaN", func() {
		opts := &AnnualizedPremiumValueOpts{OptionPrice: -1, StrikePrice: 50, OptionExpiresYearPct: 0.5}
		actual := AnnualizedPremiumValue(opts)
		c.Expect(actual, Satisfies, math.IsNaN(actual))
	})

	c.Specify("Calculates AnnualizedPremiumValue", func() {
		opts := &AnnualizedPremiumValueOpts{OptionPrice: 1, StrikePrice: 2, OptionExpiresYearPct: 3}
		actual := AnnualizedPremiumValue(opts)
		c.Expect(actual, Equals, float64(13.51550360360548))
	})

	// For example, if a stock is trading at $50 and you sell a $50 strike 6 month call for $4, you are getting
	// paid 8% in 6 months, or about 16% annualized, in exchange for being willing to buy at $50, the current price.
	c.Specify("Calculates AnnualizedPremiumValue", func() {
		opts := &AnnualizedPremiumValueOpts{OptionPrice: 4, StrikePrice: 50, OptionExpiresYearPct: 0.5}
		actual := AnnualizedPremiumValue(opts)
		c.Expect(actual, Equals, float64(15.392208227225678))
	})

}
