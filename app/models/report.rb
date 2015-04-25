require 'report_cruncher'
require 'report_loader'

class Report < ActiveRecord::Base
	belongs_to :data_set
	belongs_to :crunch_algorithm
	serialize :report_preview_rows

	def load_data
		@data = self.data_set.data
	end

	def data
		@data
	end

	def headers
		@data ? @data[0].keys.split("_").titleize : []
	end

	def file_names
		data_set.source_files.map{|sf| sf.remote_path}
	end


	def data_set_name
		if data_set
			data_set.name
		else
			"no data set found"
		end
	end
end