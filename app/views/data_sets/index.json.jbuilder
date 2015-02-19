json.array!(@data_sets) do |data_set|
  json.extract! data_set, :id, :name, :source_files
  json.url data_set_url(data_set, format: :json)
end
