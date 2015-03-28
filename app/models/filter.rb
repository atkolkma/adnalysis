module Filter

	def name
		"Filter by field"
	end

	def execute(ary)

	end

	def self.translate_form_args(args_from_form)
		ap args_from_form
		translated_args = [
			{
				dimension: args_from_form["dimension1"],
				comparison: args_from_form["comparison1"],
				value: args_from_form["value1"]
			}
		]

		if args_from_form["dimension2"] && args_from_form["dimension2"] != "select"
			translated_args << {
				dimension: args_from_form["dimension2"],
				comparison: args_from_form["comparison2"],
				value: args_from_form["value2"]
			}
		end
		translated_args
	end

	def self.form(number, algorithm)
		all_dimensions = algorithm.dimensions

		form_string = "
		#{number}) <strong>Filter:</strong>
		<input type='hidden' name='crunch_algorithm[functions][#{number}][name]' value='filter' />
		<input type='hidden' name='crunch_algorithm[functions][#{number}][new]' value='true' />
		<div class='dynamic-datatype'>
			<select  class='datatype-selector' name='crunch_algorithm[functions][#{number}][args][dimension1]'>
				<option>select</option>"
		        all_dimensions.each do |dim|
		          form_string += "<option data-datatype='#{dim[:data_type]}'>#{dim[:name]}</option>"
		        end
    	form_string += "
    		</select>
			<select class='datatype-responder numeric' name='crunch_algorithm[functions][#{number}][args][comparison1]'>
				<option>></option>
				<option>=</option>
				<option><</option>
			</select>
			<input class='datatype-responder numeric' name='crunch_algorithm[functions][#{number}][args][value1]' style='width:75px' type='number'></input>
			<select class='datatype-responder string' name='crunch_algorithm[functions][#{number}][args][comparison1]'>
				<option>equals</option>
				<option>contains</option>
				<option>contained in</option>
			</select> 
			<input class='datatype-responder string' name='crunch_algorithm[functions][#{number}][args][value1]' style='width:175px' type='text'></input>
		</div>
		<span>AND </span>
		<div class='dynamic-datatype'>
			<select class='datatype-selector' name='crunch_algorithm[functions][#{number}][args][dimension2]'>
				<option>select</option>"
		        all_dimensions.each do |dim|
		          form_string += "<option data-datatype='#{dim[:data_type]}'>#{dim[:name]}</option>"
		        end
    	form_string += "
    		</select>
			<select class='datatype-responder numeric' name='crunch_algorithm[functions][#{number}][args][comparison2]'>
				<option>></option>
				<option>=</option>
				<option><</option>
			</select>
			<input class='datatype-responder numeric' name='crunch_algorithm[functions][#{number}][args][value2]' style='width:75px' type='number'></input>
			<select class='datatype-responder string' name='crunch_algorithm[functions][#{number}][args][comparison2]'>
				<option>equals</option>
				<option>contains</option>
				<option>contained in</option>
			</select> 
			<input class='datatype-responder string' name='crunch_algorithm[functions][#{number}][args][value2]' style='width:175px' type='text'></input>
		</div>
		<br /><br />"
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
