module Calculation

	def self.evaluate(row_values, statement)
		statement = sanitize(statement)
		eval(statement.gsub('{','row_values["' ).gsub('}','"]'))
	end

	def self.sanitize(statement)
		statement
	end

end