package greeks

import "math"

func NanOrGte0(value float64) float64 {
	if math.IsNaN(value) {
		return math.NaN()
	}

	return value
}
