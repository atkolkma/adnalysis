class DataSet < ActiveRecord::Base
	serialize :source_files
	has_many :reports, foreign_key: 'data_set_id'
  mount_uploaders :source_files, SourceFileUploader
	# before_save :sanitize_source_files

	def sanitize_source_files
		self.source_files.delete_if {|file_name| file_name == '0'}
	end
end
