require 'smarter_csv'

class Report
	def self.output
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

		file = Rails.root + 'data/Search_term_report4.csv'
		table = SmarterCSV.process(file, {file_encoding: 'iso-8859-1', key_mapping: hash_key_mapping, remove_unmapped_keys: true})
		
		rows = table
		headers = rows[0].keys
		{headers: headers, rows: rows}
	end

	def self.sort(hash_table)
		rows = hash_table[:rows]
		rows = rows.sort_by{|e| [e[:match_type], -e[:converted_clicks]]}
		hash_table[:rows] = rows
		hash_table[:rows] = rows[0..1000]
		hash_table
	end

	def self.group(hash_table, dimension)
		rows = hash_table[:rows]
		dimension_values = Set.new
		all_values = rows.map{|row| row[dimension.to_sym]}.uniq
		row_groups = group_rows(rows, dimension, all_values)
		summed_array = []
		row_groups.each {|row_group| summed_array << sum_rows(row_group)}
		hash_table[:rows] = summed_array
		hash_table
	end

	def self.remove_dimensions(hash_table, dimensions=[])
		dimensions.each do |dim|

		end
	end

	def self.sum_rows(row_group)
		sum = row_group[0]
		row_group[1..20].each do |row|
			row.map do |k, v|
				sum[k] += row[k] if sum[k].is_a? Integer
				sum[k] += row[k] if sum[k].is_a? Integer
			end
		end
		sum
	end

	def self.filter_rows(report)
		
		report[:rows].keep_if do |row|
			row[:conversions] > 0			
		end
		report
	end

	def self.group_rows(rows, dimension, values)
		row_groups = Set.new
		values.each do |value|
			row_groups << rows.select {|row| row[dimension.to_sym] == value}
		end
		row_groups
	end

end