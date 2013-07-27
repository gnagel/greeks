package normal_distribution

import "math"

func NormalDistribution(value float64) float64 {
	var p float64 = 0.2316419
	var b1 float64 = 0.319381530
	var b2 float64 = -0.356563782
	var b3 float64 = 1.781477937
	var b4 float64 = -1.821255978
	var b5 float64 = 1.330274429

	y := math.Abs(value)
	z := math.Exp(-y*y/2) / math.Sqrt(2*math.Pi)
	t := 1 / (1 + p*y)
	cum := 1 - z*(b1*t+b2*t*t+b3*t*t*t+b4*t*t*t*t+b5*t*t*t*t*t)

	if value < 0 {
		cum = 1 - cum
	}

	return cum
}

func NormalDistributionGaussian(value float64) float64 {
	return math.Exp(-0.5*value*value) / math.Sqrt(2*math.Pi)
}
