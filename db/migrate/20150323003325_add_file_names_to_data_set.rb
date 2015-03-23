class AddFileNamesToDataSet < ActiveRecord::Migration
  def change
  	add_column :data_sets, :file_names, :string
  end
end
