class CreateTruncate < ActiveRecord::Migration
  def change
    create_table :truncates do |t|
    	t.integer :algorithm_id
    	t.integer :priority
    	t.integer :cutoff
    end
  end
end
