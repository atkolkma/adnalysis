class Filter < ActiveRecord::Base

	def name
		"Filter by field"
	end

	def execute(ary)

	end

	def self.args_form_to_persist(args_from_form)
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
