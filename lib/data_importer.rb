require 'csv_validator'

module DataImporter

  def self.store_data_from_csv(data_set, uploaded_csv)
    File.open(Rails.root.join('public', 'uploads', uploaded_csv.original_filename), 'wb') {|file| file.write(uploaded_csv.read)}
    uploaded_csv_location = Rails.root.join('public', 'uploads', uploaded_csv.original_filename)

    generate_dimensions(data_set)

    store_data(data_set, uploaded_csv_location)
  end

  def self.generate_dimensions(data_set)
    data_set.dimensions = data_set.data_source.dimension_translations.map {|dt| {name: dt[:translated_name], data_type: dt[:data_type]}}
  end

  def self.store_data(data_set, file)
    mapping = construct_key_mapping(data_set.data_source)
    options = {file_encoding: 'iso-8859-1', key_mapping: mapping, remove_unmapped_keys: true}

    unformatted = SmarterCSV.process(file, options)
    properly_encoded_csv = encode_csv(unformatted)

    run_validations(properly_encoded_csv, data_set.data_source)
    data_set.stored_data = properly_encoded_csv
    
    ActiveRecord::Base.logger.silence do
      data_set.save
    end
  end

  def self.encode_csv(csv)
    csv.map{|hash| hash.each{|k,v| v.force_encoding('UTF-8') if v.is_a?(String)}}
  end

  def self.construct_key_mapping(data_source)
    mapping = {}
    data_source.dimension_translations.each{|trans| mapping[trans[:original_name]] = trans[:translated_name]}
    mapping
  end

  def self.run_validations(csv, data_source)
    CsvValidator.standard_validations(csv)
    CsvValidator.custom_validations(csv, data_source)
  end

end