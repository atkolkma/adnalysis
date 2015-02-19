class Report < ActiveRecord::Base
	belongs_to :data_set
	belongs_to :crunch_algorithm

	def load_data
		file_names = data_set.source_files
		# file_names = [file_names] if file_names.is_a?(String)
		
		report_data = ReportData.new
		report_data.import(file_names)
		@data = report_data
		@file_names = file_names
		@headers = @data[0].keys
	end

	def data
		@data
	end

	def file_names
		@file_names
	end
end