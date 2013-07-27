package contract

import "fmt"
import "math"

type OptionsContractType uint8

const (
	OptionsCallContract OptionsContractType = iota
	OptionsPutContract
	// Leave open for supporting other types of contracts:
	// - American
	// - European
	// - ???
)

func IsCallContract(t OptionsContractType) bool {
	return t == OptionsCallContract
}

func IsPutContract(t OptionsContractType) bool {
	return t == OptionsPutContract
}

func OptionTypeMultiplier(t OptionsContractType) float64 {
	if IsCallContract(t) {
		return 1.0
	}

	if IsPutContract(t) {
		return -1.0
	}

	panic(fmt.Sprintf("Unknown option type = %#v", t))
	return math.NaN()
}
