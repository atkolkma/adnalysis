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

  @@algorithm_defaults_file = Rails.root + 'crunch_algorithms.yml'
  ALGORITHM_DEFAULTS = [
    {
      method_name: 'group_by_dimensions',
      ui_name:     'Group by dimensions input',
      repeat: 2,
      arguments: {
        dimension: {
          input_type:   :text,
        }
      }
    },

    {
      method_name: 'sort_by_dim',
      ui_name:     'Sort by dimensions',
      repeat: 4,
      arguments: {
        dimension: {
          input_type:   :text
        },
        direction: {
          input_type: :select,
          options: ['asc', 'desc']
        }
      }
    },

    {
      method_name: 'truncate',
      ui_name:     'Truncate',
      repeat: 1,
      arguments: {
        cutoff: {
          input_type:   :number,
            validations: {
            maximum: 100000,
            minimum: 1,
            integer: true
          }
        }
      }
    },

    {
      method_name: 'high_frequency_n_tuples',
      ui_name:     'High frequency n-tuples',
      repeat: 1,
      arguments: {
        n: {
          input_type: :number,
          validations: {
            maximum: 4,
            minimum: 1,
            integer: true
          }
        },
        numeric_dimensions: {
          input_type: :text,
          repeat: 4
        },
        text_dimensions: {
          input_type: :text
        }
      }
    },

    {
      method_name: 'frequency_of_unordered_n_tuples',
      ui_name:     'Frequency of unordered n-tuples',
      repeat: 1,
      arguments: {
        n: {
          input_type: :number,
          validations: {
            maximum: 4,
            minimum: 1,
            integer: true
          }
        },
        numeric_dimensions: {
          input_type: :text,
          repeat: 4
        },
        text_dimensions: {
          input_type: :text
        }
      }
    },

    {
      method_name: 'filter_rows_by',
      ui_name:     'Filter rows by',
      repeat:      1,
      arguments: {
        dimension: {
          input_type: :text
        },
        value: {
          input_type: :number
        },
        comparison: {
          input_type: :select,
          options: ["greater than", "less than", "equals"]
        }
      },
    }
  ]

  ap ALGORITHM_DEFAULTS

  ALLOWED_FUNCTIONS = [
    {name: "group_by_dimensions", form_input: @@group_by_dimensions_input},
    {name: "sort_by_dim", form_input: @@sort_by_dim_input},
    {name: "truncate", form_input: @@truncate_input},
    {name: "high_frequency_n_tuples", form_input: @@high_frequency_n_tuples_input},
    {name: "frequency_of_unordered_n_tuples", form_input: @@frequency_of_unordered_n_tuples_input},
    {name: "filter_rows_by", form_input: @@filter_rows_by_input},
    {name: "examples_of_substring_match", form_input: @@examples_of_substring_match_input}
  ]

private
  def set_default_functions
    self.functions ||= []
  end

end
