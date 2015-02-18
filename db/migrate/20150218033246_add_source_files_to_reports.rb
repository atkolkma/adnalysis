class AddSourceFilesToReports < ActiveRecord::Migration
  def change
    add_column :reports, :source_files, :string
  end
end
