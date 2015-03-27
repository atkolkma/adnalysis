module Sort

	def name
		"Sort by field"
	end

	 def self.translate_form_args(args_from_form)
	    [
			{
				dimension: args_from_form["dimension1"],
				direction: args_from_form["direction1"],
			},
			{
				dimension: args_from_form["dimension2"],
				direction: args_from_form["direction2"],
			}
		]
	 end

	def self.form(number, algorithm)
		(number) -> number+") <strong>Sort:</strong>
			<input type='hidden' name='crunch_algorithm[functions]["+number+"][name]' value='sort' />
			<input type='hidden' name='crunch_algorithm[functions]["+number+"][new]' value='true' />
			<select name='crunch_algorithm[functions]["+number+"][args][dimension1]'>
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select name='crunch_algorithm[functions]["+number+"][args][direction1]'>
				<option>descending</option>
				<option>ascending</option>
			</select>
			<span> AND </span>
			<select name='crunch_algorithm[functions]["+number+"][args][dimension2]'>
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select name='crunch_algorithm[functions]["+number+"][args][direction2]'>
				<option>descending</option>
				<option>ascending</option>
			</select> <br /><br />"
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