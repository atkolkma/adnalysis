require 'calculation'
module ReportCruncher

  def self.crunch(ary, functions, dimensions)
    functions.each do |f|
      ary = f["name"].constantize.send('execute', ary, f["args"], dimensions)
    end
    ary
  end

  def self.add_calculated_dimension(ary, dimension)
    ary.each do |row|
      calculated_field = {dimension[:name] => dimension[:calculation]["name"].capitalize.constantize.execute(row, dimension[:calculation]["args"])}
      row.merge!(calculated_field)
    end
    ary
  end

  def self.filter_rows_by(ary, args)
    if args["comparison"] == "greater_than"
      ary.keep_if do |row|
        row[args["dimension"]] > args["value"]
      end
    elsif args["comparison"] == less_than
      ary.keep_if do |row|
        row[args["dimension"]] < args["value"]
      end
    else
      ary
    end
  end

  def self.output_part_numbers(ary, args)
    ary = only_part_number_rows(ary, args[:string_dimension])
    ary.map{ |row| row.merge( {args[:string_dimension].to_sym => strip_part_number(row[args[:string_dimension].to_sym]) } ) }
  end

  def self.strip_part_number(string)
    string.to_s.split(' ').keep_if{|word| is_part_number?(word)}.first
  end

  def self.part_number_queries(ary, args)
    only_part_number_rows(ary, args[:string_dimension])
  end

  def self.only_part_number_rows(ary, string_dimension)
    ary.keep_if{|row| is_part_number?(row[string_dimension.to_sym])}
  end

  def self.extract_part_number(string)
    string.to_s.split(' ').keep_if{|word| is_part_number?(word)}
  end

  def self.is_part_number?(string)
    proposed_number = string.to_i
    if proposed_number > 0
      digits = num_digits(proposed_number)
      if digits > 7 && digits < 10
        return true
      end
    end
    false
  end

  def self.num_digits(number)
    Math.log10(number).to_i + 1
  end

  ### must pass hash within array
  def self.sort_by_dim(ary, arguments)
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

  def self.truncate(ary, number_of_rows)
    ary[0..number_of_rows]
  end

  def self.headers(ary)
    ary[0].keys.map{|key| key.to_s.gsub("_", " ").titleize}
  end

  def self.group_by_dimension(ary, dimension)
    with_benchmark("group by dimension: ") do 
      dimensions_to_remove = []
      ary[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || key.to_s == dimension.to_s
      end 
      ary = remove_dimensions(ary, dimensions_to_remove)

      all_values = ary.map{|row| row[dimension.to_sym]}.uniq
      row_groups = group_rows(ary, dimension, all_values)
      summed_array = []
      row_groups.each {|row_group| summed_array << sum_rows(row_group)}
      summed_array
    end
  end

  def self.group_by_dimensions(ary, dimensions)  #for only two dimensions number_of_rows
    if dimensions.length == 2
      group_by_two_dimensions(ary, dimensions)
    elsif dimensions.length == 1
      group_by_dimension(ary, dimensions[0])
    else
      raise "Invalid arguments, must include one or two dimensions in array form"
    end
  end

  def self.group_by_two_dimensions(ary, dimensions)
     dimensions_to_remove = []
      ary[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || dimensions.include?(key.to_s)
      end
      ary = remove_dimensions(ary, dimensions_to_remove)

      grouping_array = []
      dimensions.each do |dim|
        dim_values = ary.map{|row| row[dim.to_sym]}.uniq
        grouping_array << {dimension: dim, values: dim_values}
      end

      summed_array = []
      row_groups = two_dimension_group_rows(ary, grouping_array)
      row_groups.each do |row_group| 
        summed_row = sum_rows(row_group)
        summed_array << summed_row unless summed_row == []
      end
      summed_array
  end

  def self.remove_dimensions(ary, dimensions=[])
    ary.each do |row|
      row.delete_if {|k,v| dimensions.include? k}
    end
  end

  def self.high_frequency_n_tuples(ary, args)
    with_benchmark("ntuple calculation time: ") do
      summed_ngrams = {}
      ary.each do |row|
        ngrams = ngrams_from_row(row, args[:string_dimension], args[:n])
        ngrams.each do |ngram|
          sum_ngram_values(summed_ngrams, ngram, row, args[:numeric_dimensions])
        end
      end
      summed_ngrams.map{|ntuple, sum| {ngram: ntuple.to_s}.merge(sum) } 
      # summed_ngrams.map{|ntuple, sum| {ngram: ntuple.to_s}.merge(sum).merge({roi: (sum["cost"] == 0 ? 0 : (sum["total_conv_value"] / sum["cost"])) }) } 
    end
  end

  def self.sum_ngram_values(totals_hash, ngram, row, dimensions)
    if totals_hash[ngram]
      dimensions.each do |dim|
        totals_hash[ngram.to_sym][dim] += normalize_numeric_field(row[dim])
      end
    else
      totals_hash[ngram.to_sym] = {}
      dimensions.each do |dim|
        totals_hash[ngram.to_sym][dim] = normalize_numeric_field(row[dim])
      end
    end
  end

  def self.normalize_numeric_field(value)
    if value.is_a?(Numeric)
      value
    else
      value.to_f
    end
  end

  def self.filter_by_word_number(ary, args)
    ary.keep_if{|row| args[:n] <= row[args[:string_dimension]].to_s.split(' ').length}
  end

  def self.ngrams_from_row(row, string_dimension, n)
    row[string_dimension].to_s.split(' ').each_cons(n).to_a.map.each{|ntuple| ntuple.join(" ")}
  end 

  def self.examples_of_substring_match(ary, substring_ary)
    with_benchmark("examples of substring match") do
      matches = []
      substring_ary.each do |substring|
        ary.each do |row|
          if substring_match?(substring, row[:search_term])
            matches << {matcher: substring.join(' '), matches: row[:search_term]}
          else
            # do nothing
          end
        end
      end
      matches
    end
  end

  def self.frequency_of_unordered_n_tuples(ary, args)
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

private

  def self.sort_array(sort_rules)
    string_array = "["
    sort_rules.map do |rule|
      rule_string = ""
      rule_string += "-" if rule[:direction] == "desc"
      rule_string += "(e[:#{rule[:dimension]}])#{rule[:conversion]},"
      string_array += rule_string
    end

    string_array = string_array.chomp(',')
    string_array += "]"
    string_array
  end

  def self.format_for_view(results_hash)
    entries = []
    results_hash.each do |k,v|
      entries << {ngram: k.to_s, instances: v}
    end
    entries
  end

  def self.sum_rows(row_group)
    if row_group && row_group.length > 0  
      sum = row_group[0]
      row_group[1..-1].each do |row|
        row.map do |k, v|
          sum[k] += row[k].to_i if sum[k].is_a? Integer
          sum[k] = sum[k].to_f + row[k].to_f if k == :cost
          sum[k] = "n/a" if k == :cpc
        end
      end
      sum.each {|k, v| sum[k] = v.round(2) if v.is_a?(Float)}
      sum[:cpc] = (sum[:cost] / sum[:clicks].to_f).round(2)
      sum
    else
      []
    end
  end

  def self.group_rows(rows, dimension, values)
    row_groups = Set.new
    values.each do |value|
      row_groups << rows.select {|row| row[dimension.to_sym] == value}
    end
    row_groups
  end

  def self.two_dimension_group_rows(rows, grouping_array) #for only two dimensions now
    row_groups = Set.new
    outer_dimension = grouping_array[0][:dimension]
    inner_dimension = grouping_array[1][:dimension]
    grouping_array[0][:values].each do |outer_value|
      grouping_array[1][:values].each do |inner_value|
        row_groups << rows.select {|row| row[outer_dimension.to_sym] == outer_value && row[inner_dimension.to_sym] == inner_value}
      end
    end
    row_groups
  end

  def self.with_benchmark(msg = "")
    time1 = Time.now
      output = yield
    time2 = Time.now
    ap msg + (time2 - time1).to_s
    output
  end

end