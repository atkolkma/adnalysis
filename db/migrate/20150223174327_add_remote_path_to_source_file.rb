class AddRemotePathToSourceFile < ActiveRecord::Migration
  def change
  	create_table :source_files do |t|
    	t.string :remote_path
    	t.timestamps
	  end

  end
end
