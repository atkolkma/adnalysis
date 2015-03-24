class Sorting < ActiveRecord::Base

	def name
		"Sort by field"
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


end
