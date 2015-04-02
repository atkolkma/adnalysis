class Changefuncdefaultagain < ActiveRecord::Migration
  def change
  	remove_column :crunch_algorithms, :functions
  	add_column :crunch_algorithms, :functions, :json
  end
end
