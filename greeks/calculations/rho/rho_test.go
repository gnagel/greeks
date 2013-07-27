//
// Rho
//
// The change in the value of an option for a change in the prevailing interest rate that matches the duration of the option, all else held equal.

// Generally rho is not a big driver of price changes for options, as interest rates tend to be relatively stable.

package rho

import "math"
import "testing"
import "github.com/orfjackal/gospec/src/gospec"
import . "../contract"

func TestRhoSpecs(t *testing.T) {
	r := gospec.NewRunner()
	r.AddSpec(RhoSpec)
	rho.MainGoTest(r, t)
}

// Helpers
func RhoSpec(c gospec.Context) {
	c.Specify("D2NormalDistribution=NaN, returns NaN", func() {
		opts := &RhoOpts{OptionType: OptionsCallContract, OptionExpiresYearPct: float64(1.0), StrikeVsRateVsExpires: float64(2.0), D2NormalDistribution: math.NaN()}
		actual := Rho(opts)
		c.Expect(actual, gospec.Satisfies, math.IsNaN(actual))
	})

	c.Specify("Type=Call Calculates Rho", func() {
		opts := &RhoOpts{OptionType: OptionsCallContract, OptionExpiresYearPct: float64(1.0), StrikeVsRateVsExpires: float64(2.0), D2NormalDistribution: float64(3.0)}
		actual := Rho(opts)
		c.Expect(actual, gospec.Equals, float64(0.06))
	})

	c.Specify("Type=Put Calculates Rho", func() {
		opts := &RhoOpts{OptionType: OptionsPutContract, OptionExpiresYearPct: float64(1.0), StrikeVsRateVsExpires: float64(2.0), D2NormalDistribution: float64(3.0)}
		actual := Rho(opts)
		c.Expect(actual, gospec.Equals, float64(-0.06))
	})
}
