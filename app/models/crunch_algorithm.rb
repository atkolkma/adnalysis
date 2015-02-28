class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
	serialize :functions

  after_initialize :set_default_functions
  
  @@filter_rows_input = ""
  @@group_by_dimensions_input = ""
  @@sort_by_dim_input = ""
  @@high_frequency_n_tuples_input = ""
  @@frequency_of_unordered_n_tuples_input = ""
  @@truncate_input = ""

  ALLOWED_FUNCTIONS = [
    {name: "filter_rows", form_input: @@filter_rows_input},
    {name: "group_by_dimensions", form_input: @@group_by_dimensions_input},
    {name: "sort_by_dim", form_input: @@sort_by_dim_input},
    {name: "truncate", form_input: @@truncate_input},
    {name: "high_frequency_n_tuples", form_input: @@high_frequency_n_tuples_input},
    {name: "frequency_of_unordered_n_tuples", form_input: @@frequency_of_unordered_n_tuples_input}
  ]

private
  def set_default_functions
    self.functions ||= []
  end

end
