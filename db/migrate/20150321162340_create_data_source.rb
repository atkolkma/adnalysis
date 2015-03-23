class CreateDataSource < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
    	t.string :name
    	t.string :dimension_translations
    end
  end
end
