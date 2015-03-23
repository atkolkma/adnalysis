class AddJsonDataToSourceFile < ActiveRecord::Migration
  def change
  	add_column :source_files, :data, :json, default: '{}'
  end
end
