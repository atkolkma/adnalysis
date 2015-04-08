module Filter

	def self.execute(ary, args, dimensions)
    calculated_dimensions = dimensions.select{|dd| dd[:retrieve_from] == "calculation"}
    
    calculated_dimensions.each do |dim|
      if dim[:name] == args["dimension"]
        ary = ReportCruncher.add_calculated_dimension(ary, dim)
      end
    end
    
		filter_rows_by(ary, args, dimensions)
	end

	def self.form(algorithm)
		all_dimensions = algorithm.dimensions
    numeric_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "integer" || dim[:data_type] == "decimal"}
    numeric_dimensions_names = numeric_dimensions.map{|dim| dim[:name]}
    string_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "string"}
    string_dimensions_names = string_dimensions.map{|dim| dim[:name]}

    form_string = "
      <span ng-init='setNumericDimensions(#{numeric_dimensions_names})'></span>
      <span ng-init='setStringDimensions(#{string_dimensions_names})'></span>
      <select ng-model='func.args.dimension'>"
        string_dimensions.each do |sd|  
          form_string += "<option>#{sd[:name]}</option>"
        end
        numeric_dimensions.each do |nd|  
          form_string += "<option>#{nd[:name]}</option>"
        end
      form_string += "
      </select>
      <select ng-model='func.args.modifier'>
        <option selected='selected'>is</option>
        <option>not</option>
      </select>
      <select ng-show='dimensionIsNumeric(func.args.dimension)' ng-model='func.args.comparison'>
        <option>></option>
        <option>=</option>
        <option><</option>        
      </select>
      <select ng-show='dimensionIsString(func.args.dimension)' ng-model='func.args.comparison'>
        <option>equals</option>
        <option>contains</option>
        <option>contained by</option>
      </select>
      <input ng-show='dimensionIsNumeric(func.args.dimension)' type='number' ng-model='func.args.value'/>
      <input ng-show='dimensionIsString(func.args.dimension)' type='text' ng-model='func.args.value'/>"
      form_string
	end

	def self.filter_rows_by(ary, args, dimensions)
    if args["dimension"]

    end


    if args["modifier"] == "not"
      if  args["cx`omparison"] == '>'
        ary.delete_if do |row|
          row[args["dimension"]] > args["value"].to_f
        end
      elsif args["comparison"] == '<'
        ary.delete_if do |row|
          row[args["dimension"]] < args["value"].to_f
        end
      elsif args["comparison"] == '='
        ary.delete_if do |row|
          row[args["dimension"]] == args["value"].to_f
        end
      elsif args["comparison"] == 'equals'
        ary.delete_if do |row|
          row[args["dimension"]] == args["value"]
        end
      elsif args["comparison"] == 'contains'
        ary.delete_if do |row|
          row[args["dimension"]].include? args["value"]
        end
      elsif args["comparison"] == 'contained by'
        ary.delete_if do |row|
          args["value"].include? row[args["dimension"]] 
        end
      else
      end
    else
      if  args["comparison"] == '>'
        ary.keep_if do |row|
          row[args["dimension"]] && (row[args["dimension"]] > args["value"].to_f)
        end
      elsif args["comparison"] == '<'
        ary.keep_if do |row|
          row[args["dimension"]] && (row[args["dimension"]] < args["value"].to_f)
        end
      elsif args["comparison"] == '='
        ary.keep_if do |row|
          row[args["dimension"]] && (row[args["dimension"]] == args["value"].to_f)
        end
      elsif args["comparison"] == 'equals'
        ary.keep_if do |row|
          row[args["dimension"]] && (row[args["dimension"]] == args["value"])
        end
      elsif args["comparison"] == 'contains'
        ary.keep_if do |row|
          row[args["dimension"]] && (row[args["dimension"]].include? args["value"])
        end
      elsif args["comparison"] == 'contained by'
        ary.keep_if do |row|
          args["value"].include? row[args["dimension"]] 
        end
      else
      end
    end
		ary
	end

end
