class AddJsonFunctionsToCrunchAlgorithms < ActiveRecord::Migration
  def change
  	add_column :crunch_algorithms, :function_settings, :json
  end
end
