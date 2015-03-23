class AddColumnsToDataSet < ActiveRecord::Migration
  def change
  	add_column :data_sets, :stored_data, :json, default: '{}'
  	add_column :data_sets, :data_source, :integer
  	add_column :data_sets, :dimensions, :string
  end
end
