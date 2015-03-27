module Truncate

	def name
		"Truncate"
	end

	def self.translate_form_args(args_from_form)
    	args_from_form["cutoff"]
	end

	def execute(ary)
	  ary[0..number_of_rows]
	end

	def self.form(number, algorithm)
		number+") <strong>Truncate: </strong> 
			<input type='hidden' name='crunch_algorithm[functions]["+number+"][name]' value='truncate' />
			<input type='hidden' name='crunch_algorithm[functions]["+number+"][new]' value='true' />
			<input name='crunch_algorithm[functions]["+number+"][args][cutoff]' style='width:75px' type='number' />
			<br /><br />"
	end

end
