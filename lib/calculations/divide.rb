module Divide

	def self.execute(row_values, args)
		denominator = Calculation.evaluate(row_values, args["denominator"])
		numerator = Calculation.evaluate(row_values, args["numerator"])
		zero_denominator_value = Calculation.evaluate(row_values, args["zero_denominator_value"])
		
		return zero_denominator_value if denominator == 0
		numerator/denominator
	end

	def self.form
		"Numerator: <input ng-model='calculated_dimension.calculation.args.numerator' type='text' />
		Denominator: <input ng-model='calculated_dimension.calculation.args.denominator' type='text' />
		Zero Denominator Value: <input ng-model='calculated_dimension.calculation.args.zero_denominator_value' type='text' />"
	end

end