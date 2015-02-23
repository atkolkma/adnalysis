json.array!(@source_files) do |source_file|
  json.extract! source_file, :id
  json.url source_file_url(source_file, format: :json)
end
