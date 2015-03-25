class Sorting < ActiveRecord::Base

	def name
		"Sort by field"
	end

	def self.form
		"<strong>Sort:</strong>
			<span>dimension1 </span>
			<select>dimension1
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<span>direction </span>
			<select>direction1
				<option>descending</option>
				<option>ascending</option>
			</select>
			<span>dimension2 </span>
			<select>dimension2
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<span>direction </span>
			<select>direction2
				<option>descending</option>
				<option>ascending</option>
			</select> <br /><br />asdasdadsad"
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
