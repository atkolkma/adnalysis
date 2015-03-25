class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
  has_many :truncates
  has_many :sorts
  belongs_to :data_source
  serialize :dimensions
  serialize :functions
  after_initialize :set_default_functions
 

  ALLOWED_FUNCTIONS = [
    "truncate",
    "sort",
    "filter",
    "group"
  ]

private
  def set_default_functions
    self.functions ||= []
  end

end
