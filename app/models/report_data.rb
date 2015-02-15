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

  def import(file, overwrite_options={})
    @options.merge(overwrite_options)
    self.replace(SmarterCSV.process(file, @options))
  end

  def filter_rows 
    self.keep_if do |row|
      row[:conversions] > 0     
    end
    self
  end

  def sort
    self.sort_by{|e| [e[:match_type], -e[:converted_clicks]]}
    self[0..100]
  end

  ##### Unfinished ####

  def group_by_dimension(dimension)
    dimension_values = Set.new
    all_values = self.map{|row| row[dimension.to_sym]}.uniq
    row_groups = group_rows(self, dimension, all_values)
    summed_array = []
    row_groups.each {|row_group| summed_array << sum_rows(row_group)}
    self.replace(summed_array)
  end


  # def self.remove_dimensions(report_data, dimensions=[])
  #   dimensions.each do |dim|
  #   end
  # end
private

  def sum_rows(row_group)
    sum = row_group[0]
    row_group[1..20].each do |row|
      row.map do |k, v|
        sum[k] += row[k] if sum[k].is_a? Integer
        sum[k] += row[k] if sum[k].is_a? Integer
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

end