class ClearMigrations < ActiveRecord::Migration
  def change
  	  create_table :crunch_algorithms do |t|
	    t.string   :name
	    t.string   :functions
	    t.string   :type
	    t.string   :category
	    t.datetime :created_at,      null: false
	    t.datetime :updated_at,      null: false
	  end

	  create_table :data_sets do |t|
	    t.string   :name
	    t.string   :source_files
	    t.datetime :created_at,   null: false
	    t.datetime :updated_at,   null: false
	  end

	  create_table :reports do |t|
	    t.string   :name
	    t.integer  :data_set_id
	    t.integer  :crunch_algorithm_id
	    t.string   :report_preview_rows
	    t.datetime :created_at,                null: false
	    t.datetime :updated_at,                null: false
	  end

	  create_table :source_files do |t|
	    t.string   :remote_path
	    t.integer  :data_set_id
	    t.datetime :created_at,                null: false
	    t.datetime :updated_at,                null: false
	  end
  end
end
