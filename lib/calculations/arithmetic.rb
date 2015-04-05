module Arithmetic

	def self.execute(row_values, args)
		value = Calculation.evaluate(row_values, args["expression"])
		
		value
	end

	def self.form
		"<input ng-model='calculated_dimension.calculation.args.expression' type='text' />"
	end

end