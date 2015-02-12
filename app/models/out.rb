
require 'smarter_csv'

class Out
	def self.out
		file = Rails.root + 'data/Search-term-report2.csv'
		csv = SmarterCSV.process(file, {file_encoding: 'iso-8859-1'})
		ap csv[3]
	end
end