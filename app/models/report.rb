require 'smarter_csv'

class Report
	def self.output
		file = Rails.root + 'data/Search-term-report2.csv'
		table = SmarterCSV.process(file, {file_encoding: 'iso-8859-1'})
		
		rows = table[0..100]
		headers = rows[0].keys
		{headers: headers, rows: rows}
	end

	def self.sort(hash_table)
		rows = hash_table[:rows]
		rows = rows.sort_by{|e| [-1*e[:impressions], -e["avg._position".to_sym]]}
		hash_table[:rows] = rows
		ap hash_table
		hash_table
	end
end