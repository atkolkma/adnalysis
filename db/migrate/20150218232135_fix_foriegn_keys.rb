class FixForiegnKeys < ActiveRecord::Migration
  def change
    # remove_foreign_key :reports, :functional_compositions
    # remove_column :reports, :functional_composition_id

    add_column :reports, :functional_composition_id, :integer
    # add_foreign_key :reports, :functional_composition_ids
    
    add_column :reports, :data_set_id, :integer
    # add_foreign_key :reports, :data_sets


  end
end
