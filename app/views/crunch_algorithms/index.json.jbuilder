json.array!(@crunch_algorithms) do |crunch_algorithm|
  json.extract! crunch_algorithm, :id, :name, :functions, :type, :report_id
  json.url crunch_algorithm_url(crunch_algorithm, format: :json)
end
