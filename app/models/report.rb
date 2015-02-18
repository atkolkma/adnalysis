class Report < ActiveRecord::Base

	serialize :source_files
	before_save :sanitize_source_files

	def load_data
		file_names = self.source_files
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

	def sanitize_source_files
		self.source_files.delete_if {|file_name| file_name == '0'}
	end

end