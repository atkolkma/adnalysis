module Truncate

	def name
		"Truncate"
	end

	def self.translate_form_args(args_from_form)
    	args_from_form["cutoff"].to_i
	end

	def self.execute(ary, args)
	  ary[0..(args["cutoff"]-1)]
	end

	def self.hidden_form_input(function, index)
	  hidden_input = "<input type='hidden' class='function-setting' name='crunch_algorithm[functions][#{index+1}][name]' value='Truncate' />"
	  unless function[:args].blank?
	    hidden_input += "<input type='hidden' name='crunch_algorithm[functions][#{index+1}][args][cutoff]' value='#{function[:args]}' />"
	  end
	  hidden_input
	end

	def self.form(algorithm)
		"<input ng-model='func.args.cutoff' type='number' min='1'/>"
	end

end
