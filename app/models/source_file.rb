class SourceFile < ActiveRecord::Base
  belongs_to :data_set

  def s3_key
  	self.remote_path.gsub(/^.*s3.amazonaws.com\//, '')
  end

  def s3_bucket
  	ENV["S3_BUCKET"]
  end

  def name
    self.remote_path ? File.basename(self.remote_path) : ""
  end
end
