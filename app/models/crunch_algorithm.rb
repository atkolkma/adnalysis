require 'json'

class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
  has_many :truncates
  has_many :sorts
  belongs_to :data_source
  serialize :dimensions
 

  ALLOWED_FUNCTIONS = [
    "Truncate",
    "Sort",
    "Filter",
    "Group"
  ]

  def set_dimensions
    self.dimensions = self.data_source.dimension_translations.map {|dt| {name: dt[:translated_name], data_type: dt[:data_type]}}
    self.save
  end

  def function_forms
    forms = []
    ALLOWED_FUNCTIONS.each do |af|
      forms << {name: af, content: af.constantize.form(self)}
    end

    forms
  end

end
