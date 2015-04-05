require 'calculation'

class DataSource < ActiveRecord::Base
	has_many :data_sets, foreign_key: 'data_source_id'
	has_many :crunch_algorithms, foreign_key: 'data_source_id'

	serialize :dimension_translations

	ALLOWED_DATA_TYPES = [
		"integer",
		"decimal",
		"string",
		"date",
		"boolean"
	]

end
