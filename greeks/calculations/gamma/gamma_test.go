//
// Gamma
//
// A measurement of the change in delta as the price of the underlying stock changes.
//
// As the underlying stock price changes, the delta of the option changes, too. Gamma indicates how quickly your exposure to the price movement of the underlying
// security changes as the price of the underlying security varies. For example, if you have a call with a strike of $50
// and the stock price is $50, the delta likely will be approximately $0.50 for a one-dollar movement of the stock.
// At a stock price of $60, the delta will be greater, closer to $0.75. At a stock price of $40, the delta will be less,
// closer to $0.25. In this example, if the stock price changes from $50 to $60, then the delta will change from $0.50 to $0.75.
// The $10 change in stock price caused a $0.25 change in delta, so gamma is approximately $0.25/10, or $0.025, in this case.

package gamma

import "math"
import "testing"
import "github.com/orfjackal/gospec/src/gospec"

func TestGammaSpecs(t *testing.T) {
	r := gospec.NewRunner()
	r.AddSpec(GammaSpec)
	gospec.MainGoTest(r, t)
}

// Helpers
func GammaSpec(c gospec.Context) {
	c.Specify("IV=NaN, returns NaN", func() {
		opts := &GammaOpts{StockPrice: float64(1.0), OptionExpiresYearPctSqrt: float64(2.0), RateVsExpires: float64(5.0), IV: math.NaN(), ND1: float64(4.0)}
		actual := Gamma(opts)
		c.Expect(actual, gospec.Satisfies, math.IsNaN(actual))
	})

	c.Specify("ND1=NaN, returns NaN", func() {
		opts := &GammaOpts{StockPrice: float64(1.0), OptionExpiresYearPctSqrt: float64(2.0), RateVsExpires: float64(5.0), IV: float64(3.0), ND1: math.NaN()}
		actual := Gamma(opts)
		c.Expect(actual, gospec.Satisfies, math.IsNaN(actual))
	})

	c.Specify("Calculates Gamma", func() {
		opts := &GammaOpts{StockPrice: float64(1.0), OptionExpiresYearPctSqrt: float64(2.0), RateVsExpires: float64(5.0), IV: float64(3.0), ND1: float64(4.0)}
		actual := Gamma(opts)
		c.Expect(actual, gospec.Satisfies, actual >= float64(3.33) && actual <= float64(3.34))
	})
}
