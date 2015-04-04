module Truncate

	def self.execute(ary, args)
	  ary[0..(args["cutoff"]-1)]
	end

	def self.form(algorithm)
		"<input ng-model='func.args.cutoff' type='number' min='1'/>"
	end

end
