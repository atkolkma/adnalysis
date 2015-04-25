	require 'erb'

module Sort

	def self.form(algorithm)
		all_dimensions = algorithm.dimensions
		numeric_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "integer" || dim[:data_type] == "decimal"}
		string_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "string"}

		form_string = "
		<div style='display:inline' ng-init='func.args == null ? func.args = [] : null'></div>
	    <select ng-model='func.args[0].dimension'>
	      <option>select</option>"
	      numeric_dimensions.each do |nd|  
	        form_string += "<option>#{nd[:name]}</option>"
	      end
	    form_string += "
	    </select>
	    <select ng-model='func.args[0].direction'>
	        <option selected>select</option>
			<option>DESC</option>
			<option>ASC</option>
	    </select>
	    <select ng-model='func.args[1].dimension'>
	      <option>select</option>"
	      numeric_dimensions.each do |nd|  
	        form_string += "<option>#{nd[:name]}</option>"
	      end
	    form_string += "
	    </select>
	    <select ng-model='func.args[1].direction'>
	        <option selected>select</option>
			<option>DESC</option>
			<option>ASC</option>
	    </select>
	    "

			form_string
	end

	def self.execute(ary, arguments, dimensions)
	    calculated_dimensions = dimensions.select{|dd| dd[:retrieve_from] == "calculation"}
		
		calculated_dimensions.each do |dim|
			if arguments.map{|arg| arg["dimension"]}.include? dim[:name]
				ary = ReportCruncher.add_calculated_dimension(ary, dim)
			end
		end
n=0
	    ary.sort{|x,y| ap n; n+=1; @@sorting_arrays.call(x,y,arguments) }
	end

	@@sorting_arrays = lambda do |x,y,rules_hash|
	    higher_array = []
	    lower_array = []
	    
	    rules_hash.map do |rule|
	      if rule["direction"] == "DESC"
	        lower_array << x[rule["dimension"]]
	        higher_array << y[rule["dimension"]]
	      else
	        higher_array << x[rule["dimension"]]
	        lower_array << y[rule["dimension"]]
	      end
	    end
	    higher_array <=> lower_array
	end

end
