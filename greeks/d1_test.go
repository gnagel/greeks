package greeks

import "github.com/orfjackal/gospec/src/gospec"
import . "github.com/orfjackal/gospec/src/gospec"

// Helpers
func D1Spec(c gospec.Context) {
	c.Specify("Calculates D1", func() {
		opts := &D1Opts{PriceRatioLogLessRates: 1.0, OptionExpiresYearPct: 4.0, OptionExpiresYearPctSqrt: 2.0, IV: 10.0}
		actual := D1(opts)
		c.Expect(actual, Equals, float64(10.05))
	})
}
