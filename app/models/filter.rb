class Filter < ActiveRecord::Base

	def name
		"Filter by field"
	end

	def execute(ary)

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
