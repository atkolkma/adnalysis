class Truncate < ActiveRecord::Base

	def name
		"Truncate"
	end

	def execute(ary)
	  ary[0..number_of_rows]
	end

	def self.form
		"<h4>truncate</h4>"
	end

end
