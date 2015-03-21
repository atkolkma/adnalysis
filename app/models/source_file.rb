require 'smarter_csv'
require 'open-uri'

class SourceFile < ActiveRecord::Base
  belongs_to :data_set

  def s3_key
  	self.remote_path.gsub(/^.*s3.amazonaws.com\//, '')
  end

  def s3_bucket
  	ENV["S3_BUCKET"]
  end

  def name
    self.remote_path ? File.basename(self.remote_path) : ""
  end

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

  def load_data    
    if self.remote_path
      
      unformatted = SmarterCSV.process(open(self.remote_path,'r'), @@options)
      formatted = unformatted.map{|hash| hash.each{|k,v| v.force_encoding('UTF-8') if v.is_a?(String)}}
      self.data = formatted
      self.save
      ap "data loaded"
    else 
      raise "No remote file to load"
    end
  end

  def self.clicks(id)
    sql = "CREATE TEMP TABLE source_file#{id}_data(
     clicks int,
     imps int,
     keyword text,
     cost money,
     match_type text
);

SELECT id, sum(d.clicks) as clicks, sum(d.imps) as imps, sum(d.cost) as cost, d.match_type
      FROM   source_files r
      LEFT   JOIN LATERAL json_populate_recordset(null::source_file#{id}_data, r.data) d ON true
      WHERE r.id=#{id}
      GROUP BY id, match_type"
    SourceFile.connection.execute(sql).each{|line| ap line}
  end

  def self.best(id)
    sql = "CREATE TEMP TABLE source_file#{id}_data(
     clicks int,
     imps int,
     cost float,
     revenue money,
     match_type text
);

INSERT into source_file#{id}_data
SELECT sum(d.clicks) as clicks, sum(d.imps) as imps, stddev(d.cost) as cost, sum(d.revenue) as revenue, d.match_type as match_type
      FROM   source_files r
      LEFT   JOIN LATERAL json_populate_recordset(null::source_file#{id}_data, r.data) d ON true
      WHERE r.id=#{id}
      GROUP BY match_type;

SELECT *
  FROM  source_file#{id}_data"
    SourceFile.connection.execute(sql).each{|line| ap line}
  end

  def self.rows(id)
    sql = "select d->'match_type' as mt, json_agg(d->'clicks') as clks, d->'keyword' as kwd
    FROM json_array_elements((SELECT data
    FROM source_files
    WHERE id=#{id})) as d
    GROUP BY mt"
    ap SourceFile.connection.execute(sql).to_a
  end

  def parsed_data

  sql = "SELECT *
  FROM  source_file#{self.id}_data"
    ap SourceFile.connection.execute(sql).to_a
  end

end
