class CreateDataSets < ActiveRecord::Migration
  def change
    create_table :data_sets do |t|
      t.string :name
      t.string :source_files
      t.timestamps null: false
    end

    remove_column :reports, :source_files
  end
end
