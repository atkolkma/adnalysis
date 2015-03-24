class CreateFilterRows < ActiveRecord::Migration
  def change
    create_table :filter_rows do |t|
    	t.integer :algorithm_id
    	t.integer :priority
    	t.string :field
    	t.string :comparator
    	t.string :value
    end
  end
end
