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
      conversions: :conversions
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

      dimension_values = Set.new
      all_values = self.map{|row| row[dimension.to_sym]}.uniq
      row_groups = group_rows(self, dimension, all_values)
      summed_array = []
      row_groups.each {|row_group| summed_array << sum_rows(row_group, dimension)}
      self.replace(summed_array)
    end
  end

  def group_by_dimensions(dimensions)  #for only two dimensions number_of_rows
      dimensions_to_remove = []
      self[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || dimensions.unclude? key.to_s
      end 
      self.remove_dimensions(dimensions_to_remove)

      grouping_array = []
      dimensions.each do |dim|
        grouping_hash = {}
        dim_values = self.map{|row| row[dim.to_sym]}.uniq
        grouping_array << {dimension: dim, values: dim_values}
      end

      row_groups = multidimension_group_rows(self, grouping_array)
      summed_array = []
      row_groups.each {|row_group| summed_array << sum_rows(row_group, dimension)}
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

  def sum_rows(row_group, dimension)
    sum = row_group[0]
    row_group[1..-1].each do |row|
      row.map do |k, v|
        sum[k] += row[k].to_i if sum[k].is_a? Integer
      end
    end
    sum
  end

  def group_rows(rows, dimension, values)
    row_groups = Set.new
    values.each do |value|
      row_groups << rows.select {|row| row[dimension.to_sym] == value}
    end
    row_groups
  end

  def multidimension_group_rows(rows, grouping_array) #for only two dimensions now
    row_groups = Set.new
    grouping_array.each do |grouping| 
        row_groups << rows.select {|row| grouping[0][:values].includes? row[grouping[0][:dimension].to_sym] && grouping[1][:values].includes? row[grouping[1][:dimension].to_sym]}
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