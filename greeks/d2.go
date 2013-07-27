package greeks

import "math"

type D2Opts struct {
	OptionExpiresYearPctSqrt, IV, D1 float64
}

func D2(opts *D2Opts) float64 {
	if math.IsNaN(opts.IV) || math.IsNaN(opts.D1) {
		return math.NaN()
	}

	return opts.D1 - opts.IV*opts.OptionExpiresYearPctSqrt
}
