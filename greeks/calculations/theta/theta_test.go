//
// Theta
//
// The change in an option's value that an investor can expect from the passage of one day, assuming nothing else changes.
//
// Theta can be calculated in two ways, as the dollar change of the option that an investor can expect for a one-day passage of time,
// all else remaining equal, or as a percentage change in the option price for a one-day passage of time, all else remaining equal.
// For example, if an option trades at $1 on Monday morning and it has a theta of -$0.10 per day, you can expect the option to trade
// at $0.90 on Tuesday morning. Another way of measuring theta for that option is ($0.90 - $1)/$1 or -10% per day.

package theta

import "math"
import "testing"
import "github.com/orfjackal/gospec/src/gospec"
import . "../contract"

func TestThetaSpecs(t *testing.T) {
	r := gospec.NewRunner()
	r.AddSpec(ThetaSpec)
	theta.MainGoTest(r, t)
}

// Helpers
func ThetaSpec(c gospec.Context) {
	c.Specify("D2NormalDistribution=NaN, returns NaN", func() {
		opts := &ThetaOpts{OptionType: OptionsCallContract, DividendRate: float64(0.00), FedRate: float64(0.00), OptionExpiresYearPctSqrt: float64(1), StrikeVsRateVsExpires: float64(1), PriceVsRateVsExpires: float64(1), ND1: float64(1), D1NormalDistribution: float64(1), D2NormalDistribution: float64(1), IV: math.NaN()}
		actual := Theta(opts)
		c.Expect(actual, gospec.Satisfies, math.IsNaN(actual))
	})

	c.Specify("Calculates Theta", func() {
		opts := &ThetaOpts{OptionType: OptionsCallContract, DividendRate: float64(0.00), FedRate: float64(0.00), OptionExpiresYearPctSqrt: float64(1), StrikeVsRateVsExpires: float64(1), PriceVsRateVsExpires: float64(1), ND1: float64(1), D1NormalDistribution: float64(1), D2NormalDistribution: float64(1), IV: float64(1)}
		actual := Theta(opts)
		c.Expect(actual, gospec.Equals, float64(-0.0013698630136986301))
	})

	c.Specify("Type=Call Calculates Theta", func() {
		opts := &ThetaOpts{OptionType: OptionsCallContract, DividendRate: float64(1.0005), FedRate: float64(2.0002), OptionExpiresYearPctSqrt: float64(1), StrikeVsRateVsExpires: float64(3), PriceVsRateVsExpires: float64(4), ND1: float64(5), D1NormalDistribution: float64(6), D2NormalDistribution: float64(7), IV: float64(1)}
		actual := Theta(opts)
		c.Expect(actual, gospec.Equals, float64(-0.0766909589041096))
	})

	c.Specify("Type=Put Calculates Theta", func() {
		opts := &ThetaOpts{OptionType: OptionsPutContract, DividendRate: float64(1.0005), FedRate: float64(2.0002), OptionExpiresYearPctSqrt: float64(1), StrikeVsRateVsExpires: float64(3), PriceVsRateVsExpires: float64(4), ND1: float64(5), D1NormalDistribution: float64(6), D2NormalDistribution: float64(7), IV: float64(1)}
		actual := Theta(opts)
		c.Expect(actual, gospec.Equals, float64(0.021896438356164394))
	})
}
