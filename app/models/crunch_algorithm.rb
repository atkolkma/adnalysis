require 'json'
require 'functions/truncate'
require 'functions/sort'
require 'functions/group'
require 'functions/filter'

class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
  belongs_to :data_source
  serialize :dimensions

  ALLOWED_CA_TYPES = [
    "data preparation",
    "natural language processing",
    "statistical analysis",
    "general purpose"
  ]

  ALLOWED_FUNCTIONS = [
    "Truncate",
    "Sort",
    "Filter",
    "Group"
  ]

  def set_dimensions
    self.dimensions = self.data_source.dimension_translations.map {|dt| {name: dt[:translated_name], data_type: dt[:data_type], retrieve_from: "datastore"}}
    self.dimensions += self.data_source.calculated_dimensions.map {|cd| {name: cd["name"], data_type: cd["data_type"], retrieve_from: "calculation", calculation: cd["calculation"]}}
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
