require 'calculations/arithmetic'
require 'calculations/divide'

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

	def self.forms
		forms = []
		ALLOWED_CALCULATIONS.map do |ac|
			forms << {name: ac, content: ac.capitalize.constantize.form}
			ac.capitalize.constantize.form
		end
		forms
	end

end