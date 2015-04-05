module Arithmetic

	def self.execute(row_values, args)
		value = Calculation.evaluate(row_values, args["expression"])
		
		value
	end

	def self.form
		"<span ng-init='dim.calculation.args == null ? dim.calculation.args = {} : null'</span>
		<input ng-model='dim.calculation.args.expression' type='text' />"
	end

end