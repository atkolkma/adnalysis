class AddDataPrepFunctionsToDataSource < ActiveRecord::Migration
  def change
  	add_column :data_sources, :data_prep_algorithms, :string
  end
end
