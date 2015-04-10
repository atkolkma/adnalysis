module Ngrams

	def self.execute(ary, args, dimensions)
    calculated_dimensions = dimensions.select{|dd| dd[:retrieve_from] == "calculation"}
    
    if args["word_order"] == "ordered"
      ordered_ngrams(ary, args, dimensions)
    elsif args["word_order"] == "unordered"
      unordered_ngrams(ary, args, dimensions)
    else
      ary
    end

	end

	def self.form(algorithm)
    string_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "string"}
    string_dimensions_names = string_dimensions.map{|dim| dim[:name]}

    form_string = "
      <select ng-model='func.args.string_dimension'>"
        string_dimensions_names.each do |sdn|  
          form_string += "<option>#{sdn}</option>"
        end
      form_string += "
      </select>
      <select ng-model='func.args.word_order'>
        <option>ordered</option>
        <option>unordered</option>
      </select>
      <input type='number' ng-model='func.args.n'/>"
      form_string
	end

	def self.ordered_ngrams(ary, args, dimensions)
    numeric_dimensions = dimensions.select{|dim| (dim[:data_type] == "decimal" || dim[:data_type] == "integer") && dim[:retrieve_from] == "datastore"}
    # remove any dimensions that don't appear in the ary
    numeric_dimensions.keep_if{|nd| ary[0].keys.include? nd[:name] }
    summed_ngrams = {}

    ary.each do |row|
      ngrams = ngrams_from_row(row, args["string_dimension"], args["n"])
      ngrams.each do |ngram|
        sum_ngram_values(summed_ngrams, ngram, row, numeric_dimensions)
      end
    end

    summed_ngrams.map{|ntuple, sum| {ngram: ntuple.to_s}.merge(sum) } 
  end

  def self.sum_ngram_values(totals_hash, ngram, row, dimensions)

    if totals_hash[ngram]
      dimensions.each do |dim|
        totals_hash[ngram][dim[:name]] += row[dim[:name]]
      end
    else
      totals_hash[ngram] = {}
      dimensions.each do |dim|
        totals_hash[ngram][dim[:name]] = row[dim[:name]]
      end
    end
  end

  def self.ngrams_from_row(row, string_dimension, n)
    row[string_dimension].to_s.split(' ').each_cons(n).to_a.map.each{|ntuple| ntuple.join(" ")}
  end 

  #
  # Unordered Ngrams
  #

  def self.unordered_ngrams(ary, args)
    with_benchmark("set unordered ntuple calculation time: ") do 
      numeric_counts_default = {}
      args[:numeric_dimensions].each{|dim| numeric_counts_default.merge!({dim => 0})}

      set_of_ntuples = full_ntuple_set_for_rows(ary,args[:n], args[:string_dimension])
      ntuple_count = []

      set_of_ntuples.each do |ntuple|
        string_name = ""
        ntuple.map {|word| string_name << (word + " ")}
        ntuple_hash = {name: string_name, count: 0}.merge!(numeric_counts_default)

        ary.each do |row|
          if substring_match?(ntuple, row[args[:string_dimension].to_sym])
            ntuple_hash[:count] += 1
            args[:numeric_dimensions].each{ |dim| ntuple_hash[dim] += row[dim] }
          else
            # do nothing
          end
        end
        ntuple_count << ntuple_hash
      end

      ntuple_count
    end
  end

  def self.substring_match?(set_of_strings, string)
    array_of_words = string.to_s.split(" ")
    set_of_strings.each do |s|
      return false unless array_of_words.include?(s)
    end
    true
  end

  def self.full_ntuple_set_for_rows(ary, n, string_dimension)      
    full_ntuple_set = Set.new
    ary.each {|row| full_ntuple_set = full_ntuple_set.merge(unordered_ntuples_in_string(n, row[string_dimension]))}
    full_ntuple_set
  end

  def self.unordered_ntuples_in_string(n, string)
    words = string.split(" ")
    combination_array = words.combination(n)
    combination_array.map{|combination| combination.to_set}.to_set # a set of all sets of (unordered) ntuples from row.
  end

end
