require 'arithmetic'
require 'divide'

module Calculation

	ALLOWED_CALCULATIONS = [
		"arithmetic",
		"divide"
	]

	def self.evaluate(row_values, statement)
		statement = sanitize(statement)
		eval(statement.gsub('{','row_values["' ).gsub('}','"]'))
	end

	def self.sanitize(statement)
		statement
	end

end