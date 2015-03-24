class CreateSortByColumn < ActiveRecord::Migration
  def change
    create_table :sortings do |t|
    	t.integer :algorithm_id
    	t.integer :priority
    	t.string :field1
    	t.string :order1    	
    	t.string :field2
    	t.string :order2
    end
  end
end
