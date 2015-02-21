class AddColumnMappingsToCrunchAlgorithms < ActiveRecord::Migration
  def change
    add_column :crunch_algorithms, :column_mappings, :string
  end
end
