class CrunchAlgorithm < ActiveRecord::Base
	has_many :reports
	serialize :functions
  serialize :column_mappings
  
  @@filter_rows_input = ""
  @@group_by_dimensions_input = ""
  @@sort_by_dim_input = ""
  @@truncate_input = ""
  
  ALLOWED_FUNCTIONS = [
    {name: "filter_rows", form_input: @@filter_rows_input},
    {name: "group_by_dimensions", form_input: @@group_by_dimensions_input},
    {name: "sort_by_dim", form_input: @@sort_by_dim_input},
    {name: "truncate", form_input: @@truncate_input}
  ]
end
