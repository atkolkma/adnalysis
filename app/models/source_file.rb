class SourceFile < ActiveRecord::Base
  belongs_to :data_set

  def s3_key
  	self.remote_path.gsub("http://crunch-analytics-dev.s3.amazonaws.com/", '')
  end

  def s3_bucket
  	"crunch-analytics-dev"
  end

  def name
    self.remote_path ? File.basename(self.remote_path) : ""
  end
end
