class Calculation
	def self.high_frequency_n_tuples(n, hash_table)
		format_for_view([{asdfsfd: 20}, {faff:2}, {asdads:2}])
	end

	def self.format_for_view(array_of_hashes)
		string = ""
		entries = []
		array_of_hashes.each do |hash|
			hash.each do |k,v|
				entries << k.to_s + ": " + "#{v.to_s} instances"
			end
		end
		entries
	end
end