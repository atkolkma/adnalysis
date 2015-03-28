require 'erb'

module Sort

	def name
		"Sort by field"
	end

	 def self.translate_form_args(args_from_form)
	    translated_args = [
			{
				dimension: args_from_form["dimension1"],
				direction: args_from_form["direction1"]
			}
		]
		if args_from_form["dimension2"] && args_from_form["dimension2"] != "select"
			translated_args << {
				dimension: args_from_form["dimension2"],
				direction: args_from_form["direction2"]
			}
		end
		translated_args
	 end

	def self.form(number, algorithm)
		all_dimensions = algorithm.dimensions
		numeric_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "integer" || dim[:data_type] == "decimal"}
		string_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "string"}

		form_string = "#{number}) <strong>Sort:</strong>
			<input type='hidden' name='crunch_algorithm[functions][#{number}][name]' value='sort' />
			<input type='hidden' name='crunch_algorithm[functions][#{number}][new]' value='true' />
			<select name='crunch_algorithm[functions][#{number}][args][dimension1]'>
				<option>select</option>"
				numeric_dimensions.each do |nd|
					form_string += "<option>#{nd[:name]}</option>"
				end
			form_string += "</select>
			<select name='crunch_algorithm[functions][#{number}][args][direction1]'>
				<option>descending</option>
				<option>ascending</option>
			</select>
			<span> AND </span>
			<select name='crunch_algorithm[functions][#{number}][args][dimension2]'>
				<option>select</option>"
				numeric_dimensions.each do |nd|
					form_string += "<option>#{nd[:name]}</option>"
				end
			form_string += "</select>
			<select name='crunch_algorithm[functions][#{number}][args][direction2]'>
				<option>descending</option>
				<option>ascending</option>
			</select> <br /><br />"

			form_string
	end

	def execute(ary)
	    ary.sort{|x,y| @@sorting_arrays.call(x,y,arguments) }
	end

	@@sorting_arrays = lambda do |x,y,rules_hash|
	    higher_array = []
	    lower_array = []
	    
	    rules_hash.map do |rule|
	      if rule[:direction] == "desc"
	        lower_array << x[rule[:dimension].to_sym]
	        higher_array << y[rule[:dimension].to_sym]
	      else
	        higher_array << x[rule[:dimension].to_sym]
	        lower_array << y[rule[:dimension].to_sym]
	      end
	    end
	    higher_array <=> lower_array
	end

end
