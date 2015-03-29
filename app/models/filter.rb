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

	def self.form(algorithm)
		all_dimensions = algorithm.dimensions
    numeric_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "integer" || dim[:data_type] == "decimal"}
    string_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "string"}

    form_string = "
      <select ng-model='func.args.dimension'>
        <option>select</option>"
        string_dimensions.each do |sd|  
          form_string += "<option>#{sd[:name]}</option>"
        end
        numeric_dimensions.each do |nd|  
          form_string += "<option>#{nd[:name]}</option>"
        end
      form_string += "
      </select>
      <select ng-model='func.args.comparison'>
        <option>select</option>
        <option>></option>
        <option>=</option>
        <option><</option>        
        <option>equals</option>
        <option>contains</option>
        <option>contained by</option>
      </select>
      <input type='number' ng-model='func.args.value'/>"

      form_string
	end

	def self.filter_rows_by(ary, args)
		ap args
    if  args["comparison"] == '>'
      ary.keep_if do |row|
        row[args["dimension"]] > args["value"].to_f
      end
    elsif args["comparison"] == '<'
      ary.keep_if do |row|
        row[args["dimension"]] < args["value"].to_f
      end
    else
    end
		ary
	end

end
