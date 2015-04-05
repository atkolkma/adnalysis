require 'calculation'

module Divide

	def self.execute(row_values, args)
		denominator = Calculation.evaluate(row_values, args["denominator"])
		numerator = Calculation.evaluate(row_values, args["numerator"])
		zero_denominator_value = Calculation.evaluate(row_values, args["zero_denominator_value"])
		
		return zero_denominator_value if denominator == 0
		numerator/denominator
	end

	def self.form

	end

end