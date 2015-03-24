class CreateGroupByDimension < ActiveRecord::Migration
  def change
    create_table :groupings do |t|
			t.integer :algorithm_id
			t.integer :priority
			t.string :dimension1
			t.string :dimension2
    end
  end
end
