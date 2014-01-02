def FormatFloat(value, decimal_places)
	sign = value < 0 ? -1: 1;
	vv = value.abs();
	power = 10.0**decimal_places
	vv = vv * power + 0.00000001;
	vv = sign * vv.round() / power;
	vv
end
