class CreateCrunchAlgorithms < ActiveRecord::Migration
  def change
    create_table :crunch_algorithms do |t|
      t.string :name
      t.string :functions
      t.string :type

      t.timestamps null: false
    end
    add_column :reports, :crunch_algorithm_id, :integer
    # add_foreign_key :reports, :crunch_algorithms

  end
end
