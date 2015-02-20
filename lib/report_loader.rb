require 'smarter_csv'

module ReportLoader

    @@hash_key_mapping = {
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
    @@options = {file_encoding: 'iso-8859-1', key_mapping: @@hash_key_mapping, remove_unmapped_keys: true}

  def self.load_data(file_names, overwrite_options={})    
    files = file_names.map{|file_name| Rails.root + "data/#{file_name}"}

    @@options.merge(overwrite_options)
    if files.length == 1
      data = SmarterCSV.process(files[0], @@options)
    elsif files.length > 1
      data = files.map { |file| SmarterCSV.process(file, @options)}.flatten(1)
    elsif files.length < 1
      data = []
    end
    data
  end

end