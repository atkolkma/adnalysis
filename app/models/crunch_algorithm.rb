class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
	serialize :functions

  after_initialize :set_default_functions
  
  @@group_by_dimensions_input = ""
  @@sort_by_dim_input = ""
  @@high_frequency_n_tuples_input = ""
  @@frequency_of_unordered_n_tuples_input = ""
  @@truncate_input = ""
  @@filter_rows_by_input = ""
  @@examples_of_substring_match_input = ""
  @@filter_by_word_number_input = ""
  @@output_part_numbers_input = ""

  ALLOWED_FUNCTIONS = [
    {name: "group_by_dimensions", form_input: @@group_by_dimensions_input},
    {name: "sort_by_dim", form_input: @@sort_by_dim_input},
    {name: "truncate", form_input: @@truncate_input},
    {name: "high_frequency_n_tuples", form_input: @@high_frequency_n_tuples_input},
    {name: "frequency_of_unordered_n_tuples", form_input: @@frequency_of_unordered_n_tuples_input},
    {name: "filter_rows_by", form_input: @@filter_rows_by_input},
    {name: "filter_by_word_number", form_input: @@filter_by_word_number_input},
    {name: "examples_of_substring_match", form_input: @@examples_of_substring_match_input},
    {name: "output_part_numbers", form_input: @@output_part_numbers_input}
  ]

private
  def set_default_functions
    self.functions ||= []
  end

end
