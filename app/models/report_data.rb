require 'smarter_csv'

class ReportData < Array
  def initialize

    hash_key_mapping = {
      match_type: :match_type,
      search_term: :search_term,
      campaign: :campaign,
      ad_group: :adgroup,
      clicks: :clicks,
      impressions: :imps,
      "avg._cpc".to_sym => :cpc,
      cost: :cost,
      keyword: :keyword,
      converted_clicks: :converted_clicks,
      conversions: :conversions,
      "total_conv._value".to_sym => :total_conv_value,

    }
    @options = {file_encoding: 'iso-8859-1', key_mapping: hash_key_mapping, remove_unmapped_keys: true}
    super
  end

  def import(file_names, overwrite_options={})    
    files = file_names.map{|file_name| Rails.root + "data/#{file_name}"}

    @options.merge(overwrite_options)
    if files.length == 1
      data = SmarterCSV.process(files[0], @options)
    elsif files.length > 1
      data = files.map { |file| SmarterCSV.process(file, @options)}.flatten(1)
    elsif files.length < 1
      data = []
    end
    self.replace(data)
  end

  def filter_rows 
    self.keep_if do |row|
      row[:conversions] > 0
    end
    self
  end


  def sort(arguments_hash)
    self.replace(self.sort_by{|e| eval sort_array(arguments_hash) }) 
    self
  end

  def truncate(number_of_rows)
    self.replace(self[0..number_of_rows])
    self
  end

  def headers
    self[0].keys.map{|key| key.to_s.gsub("_", " ").titleize}
  end

  ##### Unfinished ####

  def group_by_dimension(dimension)
    with_benchmark("group by dimension: ") do 
      dimensions_to_remove = []
      self[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || key.to_s == dimension.to_s
      end 
      self.remove_dimensions(dimensions_to_remove)

      all_values = self.map{|row| row[dimension.to_sym]}.uniq
      row_groups = group_rows(self, dimension, all_values)
      summed_array = []
      row_groups.each {|row_group| summed_array << sum_rows(row_group)}
      self.replace(summed_array)
    end
  end

  def group_by_dimensions(dimensions)  #for only two dimensions number_of_rows
      dimensions_to_remove = []
      self[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || dimensions.include?(key.to_s)
      end
      self.remove_dimensions(dimensions_to_remove)

      grouping_array = []
      dimensions.each do |dim|
        dim_values = self.map{|row| row[dim.to_sym]}.uniq
        grouping_array << {dimension: dim, values: dim_values}
      end

      p "grouping_array: "
      ap grouping_array

      summed_array = []
      row_groups = two_dimension_group_rows(self, grouping_array)
      row_groups.each do |row_group| 
        summed_row = sum_rows(row_group)
        summed_array << summed_row unless summed_row == []
      end
      self.replace(summed_array)
  end


  def remove_dimensions(dimensions=[])
    self.each do |row|
      row.delete_if {|k,v| dimensions.include? k}
    end
  end

private

  def sort_array(sort_rules)
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

  def sum_rows(row_group)
    p "row_group: " 
    ap row_group
    if row_group && row_group.length > 1
      sum = row_group[0]
      row_group[1..-1].each do |row|
        row.map do |k, v|
          sum[k] += row[k].to_i if sum[k].is_a? Integer
          sum[k] += row[k].to_f if k == :cost
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

  def group_rows(rows, dimension, values)
    row_groups = Set.new
    values.each do |value|
      row_groups << rows.select {|row| row[dimension.to_sym] == value}
    end
    row_groups
  end

  def two_dimension_group_rows(rows, grouping_array) #for only two dimensions now
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

  def with_benchmark(msg = "")
    time1 = Time.now
      output = yield
    time2 = Time.now
    ap msg + (time2 - time1).to_s
    output
  end

end