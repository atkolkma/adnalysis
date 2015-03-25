class AddFieldsToCrunchAlgorithms < ActiveRecord::Migration
  def change
  	add_column :crunch_algorithms, :dimensions, :string
  end
end
