class AddFunctionCompositionsToReport < ActiveRecord::Migration
  def change
    add_column :reports, :function_compositions, :string
  end
end
