package greeks

import "github.com/orfjackal/gospec/src/gospec"
import "testing"

// You will need to list every spec in a TestXxx method like this,
// so that gotest can be used to run the specs. Later GoSpec might
// get its own command line tool similar to gotest, but for now this
// is the way to go. This shouldn't require too much typing, because
// there will be typically only one top-level spec per class/feature.

func TestAllSpecs(t *testing.T) {
	r := gospec.NewRunner()

	// List all specs here
	r.AddSpec(AnnualizedPremiumValueSpec)
	r.AddSpec(AnnualizedTimeValueSpec)
	r.AddSpec(ChanceOfBreakEvenSpec)
	r.AddSpec(D1Spec)
	r.AddSpec(D2Spec)
	r.AddSpec(DeltaSpec)
	r.AddSpec(GammaSpec)
	r.AddSpec(IntrinsicValueSpec)
	// r.AddSpec(IvSpec)
	r.AddSpec(Nd1Spec)
	r.AddSpec(NormalDistributionSpec)
	r.AddSpec(RhoSpec)
	r.AddSpec(ThetaSpec)
	r.AddSpec(TimeValueSpec)
	r.AddSpec(VegaSpec)

	// Run GoSpec and report any errors to gotest's `testing.T` instance
	gospec.MainGoTest(r, t)
}
