module Filter

	def name
		"Filter by field"
	end

	def execute(ary)

	end

	def self.translate_form_args(args_from_form)
		[
			{
				dimension: args_from_form["dimension1"],
				comparison: args_from_form["comparison1"],
				value: args_from_form["value1"]
			},
			{
				dimension: args_from_form["dimension2"],
				comparison: args_from_form["comparison2"],
				value: args_from_form["value2"]
			}
		]
	end

	def self.form(number, algorithm)
		all_dimensions = algorithm.dimensions

		form_string = "#{number}) <strong>Filter:</strong>
			<input type='hidden' name='crunch_algorithm[functions][#{number}][name]' value='filter' />
			<input type='hidden' name='crunch_algorithm[functions][#{number}][new]' value='true' />
			<select name='crunch_algorithm[functions][#{number}][args][dimension1]'>
				<option>select</option>"
		        all_dimensions.each do |dim|
		          form_string += "<option>#{dim[:name]}</option>"
		        end
      form_string += "</select>
			<select name='crunch_algorithm[functions][#{number}][args][comparison1]'>
				<option>></option>
				<option>=</option>
				<option><</option>
			</select>
			<input name='crunch_algorithm[functions][#{number}][args][value1]' style='width:75px' type='number'></input>
			<span>AND </span>
			<select name='crunch_algorithm[functions][#{number}][args][dimension2]'>
				<option>select</option>"
		        all_dimensions.each do |dim|
		          form_string += "<option>#{dim[:name]}</option>"
		        end
      form_string += "</select>
			<select name='crunch_algorithm[functions][#{number}][args][comparison2]'>
				<option>></option>
				<option>=</option>
				<option><</option>
			<span>Value</span>
			<input name='crunch_algorithm[functions][#{number}][args][value2]' style='width:75px' type='number'></input>
			</select> <br /><br />"
			form_string
	end

	def self.filter_rows_by(ary, args)
	    if args[:comparison] == :greater_than
	      ary.keep_if do |row|
	        row[args[:dimension]] > args[:value]
	      end
	    elsif args[:comparison] == :less_than
	      ary.keep_if do |row|
	        row[args[:dimension]] < args[:value]
	      end
	    else
	      ary
	    end
	  end

end
