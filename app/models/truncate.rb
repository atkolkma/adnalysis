class Truncate < ActiveRecord::Base

	def name
		"Truncate"
	end

	def execute(ary)
	  ary[0..number_of_rows]
	end

end
