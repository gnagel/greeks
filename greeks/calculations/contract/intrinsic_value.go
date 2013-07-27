//
// Intrinsic Value
//
// The value that the option would pay if it were executed today.
//
// For example, if a stock is trading at $40, a call on that stock with a strike price of $35
// would have $5 of intrinsic value ($40-$35) if it were  exercised today. However, the call
// should actually be worth more than $5 to account for the value of the  chance of any further
// appreciation until expiration, and the difference between the price and the intrinsic value
// would be the time value.

package greeks

type IntrinsicValueOpts struct {
	OptionType              OptionsContractType
	StockPrice, StrikePrice float64
}

func IntrinsicValue(opts *IntrinsicValueOpts) float64 {
	var a, b float64

	if IsCallContract(opts.OptionType) {
		a = opts.StockPrice
		b = opts.StrikePrice
	} else {
		a = opts.StrikePrice
		b = opts.StockPrice
	}

	c := a - b
	return NanOrGte0(c)
}
