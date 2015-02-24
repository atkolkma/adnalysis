class SourceFile < ActiveRecord::Base
  belongs_to :data_set

  def name
    self.remote_path ? File.basename(self.remote_path) : ""
  end
end
