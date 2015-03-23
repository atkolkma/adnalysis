module DataImporter

  def self.store_data_from_csv(data_set, uploaded_csv)
    File.open(Rails.root.join('public', 'uploads', uploaded_csv.original_filename), 'wb') {|file| file.write(uploaded_csv.read)}
    uploaded_csv_location = Rails.root.join('public', 'uploads', uploaded_csv.original_filename)

    generate_dimensions(data_set)

    ActiveRecord::Base.logger.silence do
      data_set.store_data(uploaded_csv_location)
    end
  end

  def self.generate_dimensions(data_set)
    data_set.dimensions = data_set.data_source.dimension_translations.map {|dt| {name: dt[:translated_name], data_type: dt[:data_type]}}
  end

end