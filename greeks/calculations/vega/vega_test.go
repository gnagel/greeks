//
// Vega
//
// The change in the price of an option for a change in the implied volatility of the option, all else held equal.
//
// In general, as the options market thinks it is more difficult to value a stock, implied volatility and therefore
// the price of the options will increase. For example, if an option is trading for $1, the implied volatility is 20%,
// and the vega is $0.05, then a one-percentage-point increase in implied volatility to 21% would correspond to an increase in
// the price of the option to $1.05. In percentage terms, the vega in this case would be ($0.05/$1.00)/(1 percentage point) = 5%.

package vega

import "math"
import "testing"
import "github.com/orfjackal/gospec/src/gospec"

func TestVegaSpecs(t *testing.T) {
	r := gospec.NewRunner()
	r.AddSpec(VegaSpec)
	gospec.MainGoTest(r, t)
}

// Helpers
func VegaSpec(c gospec.Context) {
	c.Specify("ND1=NaN, returns NaN", func() {
		opts := &VegaOpts{PriceVsRateVsExpires: float64(1), OptionExpiresYearPctSqrt: float64(1), ND1: math.NaN()}
		actual := Vega(opts)
		c.Expect(actual, gospec.Satisfies, math.IsNaN(actual))
	})

	c.Specify("Calculates Vega", func() {
		opts := &VegaOpts{PriceVsRateVsExpires: float64(1), OptionExpiresYearPctSqrt: float64(1), ND1: float64(1)}
		actual := Vega(opts)
		c.Expect(actual, gospec.Equals, float64(0.01))
	})

	c.Specify("Calculates Vega", func() {
		opts := &VegaOpts{PriceVsRateVsExpires: float64(3), OptionExpiresYearPctSqrt: float64(1), ND1: float64(2)}
		actual := Vega(opts)
		c.Expect(actual, gospec.Equals, float64(0.06))
	})

	c.Specify("Calculates Vega", func() {
		opts := &VegaOpts{PriceVsRateVsExpires: float64(10), OptionExpiresYearPctSqrt: float64(5), ND1: float64(10)}
		actual := Vega(opts)
		c.Expect(actual, gospec.Equals, float64(5.0))
	})
}
