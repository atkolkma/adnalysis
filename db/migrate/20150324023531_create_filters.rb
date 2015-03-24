class CreateFilters < ActiveRecord::Migration
  def change
  	drop_table :filter_rows
    add_column :filters, :algorithm_id, :integer
    add_column :filters, :priority, :integer
    add_column :filters, :string, :string
    add_column :filters, :comparison, :string
    add_column :filters, :value, :string
  end
end
