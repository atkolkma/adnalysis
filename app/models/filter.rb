module Filter

	def name
		"Filter by field"
	end

	def self.args_template
		{
			dimension: dim,
			comparison: {
				string: ['equals', 'contains', 'contained by'],
				numeric: ['>', '=', '<']
			}
		}
	end

	def self.execute(ary, args)
		filter_rows_by(ary, args)
	end

	def self.translate_form_args(args_from_form)
			{
				dimension: args_from_form["dimension"],
				comparison: args_from_form["comparison"],
				value: args_from_form["value"].to_i
			}
	end

	def self.hidden_form_input(function, index)
		ap function
		hidden_input = "<input type='hidden' class='function-setting' name='crunch_algorithm[functions][#{index+1}][name]' value='Filter' />"
	  unless function[:args].blank?
	    hidden_input += "<input type='hidden' name='crunch_algorithm[functions][#{index+1}][args][dimension]' value='#{function[:args][:dimension]}' />"+
	    "<input type='hidden' name='crunch_algorithm[functions][#{index+1}][args][comparison]' value='#{function[:args][:comparison]}' />"+
	    "<input type='hidden' name='crunch_algorithm[functions][#{index+1}][args][value]' value='#{function[:args][:value]}' />"
	  end
		hidden_input
	end

	def self.form(number, algorithm)
		all_dimensions = algorithm.dimensions

		form_string = "
		#{number}) <strong>Filter:</strong>
		<input type='hidden' name='crunch_algorithm[functions][#{number}][name]' value='Filter' />
		<div class='dynamic-datatype'>
			<select  class='datatype-selector' name='crunch_algorithm[functions][#{number}][args][dimension]'>
				<option>select</option>"
		        all_dimensions.each do |dim|
		          form_string += "<option data-datatype='#{dim[:data_type]}'>#{dim[:name]}</option>"
		        end
    	form_string += "
    		</select>
			<select class='datatype-responder numeric' name='crunch_algorithm[functions][#{number}][args][comparison]'>
				<option>></option>
				<option>=</option>
				<option><</option>
			</select>
			<input class='datatype-responder numeric' name='crunch_algorithm[functions][#{number}][args][value]' style='width:75px' type='number'></input>
			<select class='datatype-responder string' name='crunch_algorithm[functions][#{number}][args][comparison]'>
				<option>equals</option>
				<option>contains</option>
				<option>contained in</option>
			</select> 
			<input class='datatype-responder string' name='crunch_algorithm[functions][#{number}][args][value]' style='width:175px' type='text'></input>
		</div>
		<br /><br />"
		form_string
	end

	def self.filter_rows_by(ary, args)
    if  args[:comparison] == '>'
      ary.keep_if do |row|
        row[args[:dimension]] > args[:value].to_f
      end
    elsif args[:comparison] == '<'
      ary.keep_if do |row|
        row[args[:dimension]] < args[:value].to_f
      end
    else
    end
		ary
	end

end
