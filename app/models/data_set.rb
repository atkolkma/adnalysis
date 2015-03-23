class DataSet < ActiveRecord::Base
	has_many :source_files
	has_many :reports, foreign_key: 'data_set_id'
	belongs_to :data_source
	serialize :dimensions
  serialize :data
  serialize :file_names

  def data
    self.stored_data
  end

end
