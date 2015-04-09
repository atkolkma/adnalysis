module Divide

	def self.execute(row_values, args)
		denominator = Calculation.evaluate(row_values, args["denominator"])
		numerator = Calculation.evaluate(row_values, args["numerator"])
		zero_denominator_value = Calculation.evaluate(row_values, args["zero_denominator_value"])
		
		return zero_denominator_value if denominator == 0
		if (numerator.is_a? Numeric) && (denominator.is_a? Numeric)
			(numerator/denominator).round(2)
		else
			0
		end
	end

	def self.form
		"<span ng-init='dim.calculation.args  == null ? dim.calculation.args = {} : null'</span>
		Numerator: <input ng-model='dim.calculation.args.numerator' type='text' />
		Denominator: <input ng-model='dim.calculation.args.denominator' type='text' />
		Zero Denominator Value: <input ng-model='dim.calculation.args.zero_denominator_value' type='text' />"
	end

end