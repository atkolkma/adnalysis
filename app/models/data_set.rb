class DataSet < ActiveRecord::Base
	has_many :source_files
	has_many :reports, foreign_key: 'data_set_id'
	belongs_to :data_source
	serialize :dimensions
  serialize :data
  serialize :file_names
	
  # before_create :generate_dimensions

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


	def sanitize_source_files
		self.source_files.delete_if {|file_name| file_name == '0'}
	end

  def data
    self.stored_data
  end

	def store_data(file)
    unformatted = SmarterCSV.process(file, @@options)
    formatted = unformatted.map{|hash| hash.each{|k,v| v.force_encoding('UTF-8') if v.is_a?(String)}}
    self.stored_data = formatted
    self.save
    ap "data loaded"
  end

  def generate_dimensions
    self.dimensions = self.data_source.dimension_translations.map {|dt| {name: dt[:translated_name], data_type: dt[:data_type]}}
  end
end
