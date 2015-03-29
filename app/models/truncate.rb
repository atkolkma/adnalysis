module Truncate

	def name
		"Truncate"
	end

	def self.translate_form_args(args_from_form)
    	args_from_form["cutoff"].to_i
	end

	def self.execute(ary, cutoff)
	  ary[0..(cutoff-1)]
	end

	def self.hidden_form_input(function, index)
	  hidden_input = "<input type='hidden' class='function-setting' name='crunch_algorithm[functions][#{index+1}][name]' value='Truncate' />"
	  unless function[:args].blank?
	    hidden_input += "<input type='hidden' name='crunch_algorithm[functions][#{index+1}][args][cutoff]' value='#{function[:args]}' />"
	  end
	  hidden_input
	end

	def self.form(number, algorithm)
		"#{number}) <strong>Truncate: </strong> 
			<input type='hidden' name='crunch_algorithm[functions][#{number}][name]' value='Truncate' />
			<input name='crunch_algorithm[functions][#{number}][args][cutoff]' style='width:75px' type='number' />
			<br /><br />"
	end

end
