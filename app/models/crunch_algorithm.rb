require 'json'

class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
  has_many :truncates
  has_many :sorts
  belongs_to :data_source
  serialize :dimensions
  serialize :functions
  after_initialize :set_default_functions
 

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

  def self.hidden_form_input(function, index)
    function[:name].constantize.hidden_form_input(function, index)
  end

  def self.parsed_functions_from_form(functions_from_form)
    ap functions_from_form
    return functions_from_form unless functions_from_form
    parsed_functions = []
    functions_from_form.each do |number, func|
      parsed_functions << func if func["name"] != ""
    end
    parsed_functions.map{|func| {name: func[:name], args: func[:name].capitalize.constantize.translate_form_args(func[:args])}}
  end

private
  def set_default_functions
    self.functions ||= []
  end

end
