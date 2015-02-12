require 'smarter_csv'

class Report
	def self.output
		file = Rails.root + 'data/Search-term-report2.csv'
		table = SmarterCSV.process(file, {file_encoding: 'iso-8859-1'})
		
		rows = table
		headers = rows[0].keys
		{headers: headers, rows: rows}
	end

	def self.sort(hash_table)
		rows = hash_table[:rows]
		rows = rows.sort_by{|e| [-1*e[:converted_clicks], -e["avg._position".to_sym]]}
		hash_table[:rows] = rows
		hash_table[:rows] = rows[0..100]
		hash_table
	end

	def self.group(hash_table, dimension)
		rows = hash_table[:rows]
		dimension_values = Set.new
		all_values = rows.map{|row| row[dimension.to_sym]}.uniq
		row_groups = group_rows(rows, dimension, all_values)
		summed_array = []
		row_groups.each {|row_group| summed_array << sum_rows(row_group)}
		ap summed_array
	end

	def self.sum_rows(row_group)
		sum = row_group[0]
		row_group[1..20].each do |row|
			row.map do |k, v|
				sum[k] += row[k] if sum[k].is_a? Integer
			end
		end
		sum
	end

	def self.group_rows(rows, dimension, values)
		row_groups = []
		values.each do |value|
			row_groups << rows.select {|row| row[dimension.to_sym] == value}
		end
		row_groups
	end

end