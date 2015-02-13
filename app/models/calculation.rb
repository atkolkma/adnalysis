class Calculation
	def self.high_frequency_n_tuples(n, hash_table)

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
				bigrams = row[:search_term].split(' ').each_cons(3).to_a.map.each{|twotuple| twotuple.join(" ")}
				bigrams.each do |bigram|
					list_of_bigrams[bigram.to_sym] ? list_of_bigrams[bigram.to_sym] += row[:converted_clicks] : list_of_bigrams[bigram.to_sym] = row[:converted_clicks]
				end
			end
			list_of_bigrams = list_of_bigrams.sort_by{|bigram,times| -1*times}
			format_for_view(list_of_bigrams[0..100])
		end
		
	end

	def self.format_for_view(results_hash)
		entries = []
		results_hash.each do |k,v|
			entries << k.to_s + ": " + "#{v.to_s} instances"
		end
		entries
	end
end