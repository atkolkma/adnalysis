class AddDataSetIdToSourceFiles < ActiveRecord::Migration
  def change
  	add_column :source_files, :data_set_id, :integer
  end
end
