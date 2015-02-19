class AddCategoryToCrunchAlgorithms < ActiveRecord::Migration
  def change
    add_column :crunch_algorithms, :category, :string
  end
end
