class ChangeFunctionDefaults < ActiveRecord::Migration
  def change
  	change_column_default :crunch_algorithms, :functions, []
  end
end
