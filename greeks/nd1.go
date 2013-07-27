package greeks

import "math"

func Nd1(d1 float64) float64 {
	if math.IsNaN(d1) {
		return math.NaN()
	}

	return math.Exp(-0.5*d1*d1) / math.Sqrt(2*math.Pi)
}
