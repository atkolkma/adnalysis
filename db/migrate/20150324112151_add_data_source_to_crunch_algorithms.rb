class AddDataSourceToCrunchAlgorithms < ActiveRecord::Migration
  def change
  	add_column :crunch_algorithms, :data_source_id, :integer
  end
end
