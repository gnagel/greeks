package normal_distribution


import "testing"
import "github.com/orfjackal/gospec/src/gospec"

func TestNormalDistributionSpecs(t *testing.T) {
	r := gospec.NewRunner()
	r.AddSpec(NormalDistributionSpec)
	gospec.MainGoTest(r, t)
}

// Helpers
func NormalDistributionSpec(c gospec.Context) {
	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(-0.0)
		c.Expect(actual, gospec.Equals, float64(0.5000000005248086))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.038237059844021946)
		c.Expect(actual, gospec.Equals, float64(0.5152507249371991))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.038410221197121876)
		c.Expect(actual, gospec.Equals, float64(0.5153197557441735))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.05419795049563356)
		c.Expect(actual, gospec.Equals, float64(0.5216113427954938))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.08866836079942457)
		c.Expect(actual, gospec.Equals, float64(0.5353273260368764))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.22705303864277918)
		c.Expect(actual, gospec.Equals, float64(0.5898087102891723))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.23102722425730948)
		c.Expect(actual, gospec.Equals, float64(0.5913531319833535))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.24375225242810844)
		c.Expect(actual, gospec.Equals, float64(0.5962886004762329))
	})

	c.Specify("Calcualtes NormalDistribution", func() {
		actual := NormalDistribution(0.24745839358343474)
		c.Expect(actual, gospec.Equals, float64(0.5977232060736917))
	})
}
