//
// Delta
//
// A measurement of the change in the price of an option resulting from a change in the price of the underlying security.
//
// Delta is positive for calls and negative for puts. Delta can be calculated as the dollar change of the option that an
// investor can expect for a one-dollar change in the underlying security. For example, let's say an option on a stock
// trading at $50 costs $1 and has a delta of $0.50 per dollar of underlying stock price change. If the stock price rises
// to $52, the price of the option will increase by $1 (the $2 price change times the $0.50 delta). After the stock price
// movement, the option will be worth $2 ($1 initial cost plus $1 delta). Delta can also be calculated as a percentage
// change in the option price for a one-percent change in the underlying security; this method of viewing the delta value
// is also known as "leverage."

package delta

import "math"
import "testing"
import "github.com/orfjackal/gospec/src/gospec"

func TestDeltaSpecs(t *testing.T) {
	r := gospec.NewRunner()
	r.AddSpec(DeltaSpec)
	gospec.MainGoTest(r, t)
}


// Helpers
func DeltaSpec(c gospec.Context) {
	c.Specify("D1NormalDistribution=NaN, returns NaN", func() {
		opts := &DeltaOpts{IsCallContract: true, RateVsExpires: float64(1.0), D1NormalDistribution: math.NaN()}
		actual := Delta(opts)
		c.Expect(actual, gospec.Satisfies, math.IsNaN(actual))
	})

	c.Specify("Call Contract returns positive", func() {
		opts := &DeltaOpts{IsCallContract: true, RateVsExpires: float64(2.0), D1NormalDistribution: float64(3.0)}
		actual := Delta(opts)
		expected := float64(6.0)
		c.Expect(actual, gospec.Equals, expected)
	})

	c.Specify("Put Contract returns negative", func() {
		opts := &DeltaOpts{IsCallContract: false, RateVsExpires: float64(2.0), D1NormalDistribution: float64(3.0)}
		actual := Delta(opts)
		expected := float64(-6.0)
		c.Expect(actual, gospec.Equals, expected)
	})
}
