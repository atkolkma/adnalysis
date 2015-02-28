module ReportCruncher

  def self.crunch(ary, functions)
    functions.each do |f|
      ary = self.send(f[:name], ary, f[:args])
    end
    ary
  end

  def self.filter_rows(ary, num)
    ary.keep_if do |row|
      row[:conversions] > num
    end
  end

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

  ##### Unfinished ####

  def self.group_by_dimension(ary, dimension)
    with_benchmark("group by dimension: ") do 
      dimensions_to_remove = []
      ary[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || key.to_s == dimension.to_s
      end 
      ary.remove_dimensions(dimensions_to_remove)

      all_values = ary.map{|row| row[dimension.to_sym]}.uniq
      row_groups = group_rows(ary, dimension, all_values)
      summed_array = []
      row_groups.each {|row_group| summed_array << sum_rows(row_group)}
      summed_array
    end
  end

  def self.group_by_dimensions(ary, dimensions)  #for only two dimensions number_of_rows
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

  def self.high_frequency_n_tuples(ary, n)
    with_benchmark("ntuple calculation time: ") do 
      summed_ngrams = {}
      
      ary.each do |row|
        ngrams = ngrams_from_row(row, n)
        ngrams.each do |ngram|
          sum_ngram_values(summed_ngrams, ngram, row, [:converted_clicks, :conversions, :cost, :total_conv_value])
        end
      end

      summed_ngrams.map{|ntuple, sum| {ngram: ntuple.to_s}.merge(sum) } 
    end
  end

  def self.sum_ngram_values(totals_hash, ngram, row, dimensions)
    if totals_hash[ngram.to_sym]
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

  def self.ngrams_from_row(row, n)
    row[:search_term].split(' ').each_cons(n).to_a.map.each{|ntuple| ntuple.join(" ")}
  end

  def self.frequency_of_unordered_n_tuples(ary, n)
    with_benchmark("set unordered ntuple calculation time: ") do 
    
      list_of_ntuples = []
      ary.each do |row|
        list_of_ntuples << unordered_ntuples(n, row)
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
    combinations
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
    if row_group && row_group.length > 1
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