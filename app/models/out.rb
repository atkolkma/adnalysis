
require 'smarter_csv'

class Report
	def new
		file = Rails.root + 'data/Search-term-report2.csv'
		@table = SmarterCSV.process(file, {file_encoding: 'iso-8859-1'})
	end
end