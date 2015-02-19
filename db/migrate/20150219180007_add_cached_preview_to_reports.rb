class AddCachedPreviewToReports < ActiveRecord::Migration
  def change
    add_column :reports, :report_preview_rows, :string
  end
end
