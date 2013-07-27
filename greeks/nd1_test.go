package greeks

import "github.com/orfjackal/gospec/src/gospec"
import . "github.com/orfjackal/gospec/src/gospec"

// Helpers
func Nd1Spec(c gospec.Context) {
	c.Specify("Calculates ND1", func() {
		actual := Nd1(1.0)
		c.Expect(actual, Equals, float64(0.24197072451914337))
	})
}
