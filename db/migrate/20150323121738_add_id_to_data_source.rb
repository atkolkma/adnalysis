class AddIdToDataSource < ActiveRecord::Migration
  def change
  	rename_column :data_sets, :data_source, :data_source_id
  end
end
