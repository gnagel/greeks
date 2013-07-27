package greeks

import "github.com/orfjackal/gospec/src/gospec"
import . "github.com/orfjackal/gospec/src/gospec"

// Helpers
func D2Spec(c gospec.Context) {
	c.Specify("Calculates D2", func() {
		opts := &D2Opts{OptionExpiresYearPctSqrt: 1.0, IV: 2.0, D1: 3.0}
		actual := D2(opts)
		c.Expect(actual, Equals, float64(1.0))
	})
}
