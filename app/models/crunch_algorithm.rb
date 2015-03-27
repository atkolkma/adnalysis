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

  def set_dimensions
    self.dimensions = self.data_source.dimension_translations.map {|dt| {name: dt[:translated_name], data_type: dt[:data_type]}}
    self.save
  end

  def self.parsed_functions_from_form(functions_from_form)
    return functions_from_form unless functions_from_form
    parsed_functions = []
    functions_from_form.each do |number, func|
      parsed_functions << func if func["name"] != ""
    end
    parsed_functions.map{|func| func[:new] ? {name: func[:name], args: func[:name].capitalize.constantize.translate_form_args(func[:args])} : func}
  end

private
  def set_default_functions
    self.functions ||= []
  end

end
