class AddFilesToDataSets < ActiveRecord::Migration
  def change
    add_column :data_sets, :files, :json
  end
end
