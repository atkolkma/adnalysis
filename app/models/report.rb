require 'smarter_csv'

class Report
	def self.output
		file = Rails.root + 'data/Search-term-report2.csv'
		table = SmarterCSV.process(file, {file_encoding: 'iso-8859-1'})
		
		table = table[0..100]
		headers = table[0].keys
		{headers: headers, table: table}
	end
end