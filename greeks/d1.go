package greeks

import "math"

type D1Opts struct {
	OptionExpiresYearPct, OptionExpiresYearPctSqrt, PriceRatioLogLessRates, IV float64
}

func D1(opts *D1Opts) float64 {
	if math.IsNaN(opts.IV) {
		return math.NaN()
	}

	return (opts.PriceRatioLogLessRates + opts.IV*opts.IV*opts.OptionExpiresYearPct/2) / (opts.IV * opts.OptionExpiresYearPctSqrt)
}
