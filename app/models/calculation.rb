class Calculation

	def self.high_frequency_n_tuples(n, hash_table)
		with_benchmark("ntuple calculation time: ") do 
			if n == 1
				list_of_words = {}
				hash_table.each	do |row|
					phrase = row[:search_term]
					phrase.split(" ").each do |word|
						list_of_words[word.to_sym] ? list_of_words[word.to_sym] += row[:converted_clicks] : list_of_words[word.to_sym] = row[:converted_clicks]
					end
				end
				list_of_words = list_of_words.sort_by{|word,times| -1*times}
				format_for_view(list_of_words)
			elsif n==2
				list_of_bigrams = {}
				hash_table.each	do |row|
					bigrams = row[:search_term].split(' ').each_cons(2).to_a.map.each{|twotuple| twotuple.join(" ")}
					bigrams.each do |bigram|
						list_of_bigrams[bigram.to_sym] ? list_of_bigrams[bigram.to_sym] += row[:converted_clicks] : list_of_bigrams[bigram.to_sym] = row[:converted_clicks]
					end
				end
				list_of_bigrams = list_of_bigrams.sort_by{|bigram,times| -1*times}
				format_for_view(list_of_bigrams[0..100])
			end
		end
		
	end

	def self.frequency_of_unordered_n_tuples(n, hash_table)
		with_benchmark("set unordered ntuple calculation time: ") do 
		
			list_of_ntuples = []
			hash_table.each do |row|
				list_of_ntuples << unordered_ntuples(2, row)
			end

			ntuple_count = {}

			list_of_ntuples.each do |ntuple_group|
				ntuple_group.each do |ntuple|
					string_name = ""
					ntuple.map do |word|
						string_name << (word + " ")
					end
					ntuple_count[string_name.to_sym] = 0
					list_of_ntuples.each do |inner_ntuple_group|
						inner_ntuple_group.each do |inner_ntuple|
							ntuple_count[string_name.to_sym] += 1 if ntuple == inner_ntuple 
							inner_ntuple_group.delete(inner_ntuple) if ntuple == inner_ntuple
						end
					end
				end
			end

			ntuple_count = ntuple_count.sort_by{|ntuple,times| -1*times}
			format_for_view(ntuple_count[0..100])
		end
	end

	def self.unordered_ntuples(n, row)
		words = row[:search_term].split(" ")
		combinations = words.combination(n).to_set
		ap combinations
		combinations
	end

	def self.format_for_view(results_hash)
		entries = []
		results_hash.each do |k,v|
			entries << k.to_s + ": " + "#{v.to_s} instances"
		end
		entries
	end

	private

	def self.with_benchmark(msg = "")
		time1 = Time.now
			result = yield
		time2 = Time.now

		ap msg + (time2 - time1).to_s

		result
	end
end