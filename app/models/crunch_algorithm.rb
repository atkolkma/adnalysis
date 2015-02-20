class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
	serialize :functions
end
