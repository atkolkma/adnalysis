class AddRemotePathToSourceFile < ActiveRecord::Migration
  def change
    add_column :source_files, :remote_path, :string
  end
end
