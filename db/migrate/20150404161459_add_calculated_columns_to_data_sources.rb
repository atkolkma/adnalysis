class AddCalculatedColumnsToDataSources < ActiveRecord::Migration
  def change
  	add_column :data_sources, :calculated_dimensions, :json, default: []
  end
end
