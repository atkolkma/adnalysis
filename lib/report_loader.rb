require 'smarter_csv'
require 'open-uri'

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
      matched_search_query: :matched_search_query,
      revenue: :revenue,
      quantity: :quantity,
      query: :query,
      "Impressions".to_sym => :impressions,
      "CTR".to_sym => :ctr,
      "Avg._position".to_sym => :avg_position,
      "Avgposition".to_sym => :avg_position
    }

    @@options = {file_encoding: 'iso-8859-1', key_mapping: @@hash_key_mapping, remove_unmapped_keys: true}

  def self.load_data(urls, overwrite_options={})    
    @@options.merge(overwrite_options)
    
    if urls.length == 1
      data = SmarterCSV.process(open(urls[0],'r'), @@options)
      ap "data loaded"
    elsif urls.length > 1
      # data = SmarterCSV.process(open(file,'r'), @@options)
      data = urls.map { |file| SmarterCSV.process(open(file,'r'), @@options)}.flatten(1)
    elsif urls.length < 1
      data = []
    end
    data
  end

end