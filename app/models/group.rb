module Group

  def name
    "group by dimension"
  end

  def execute(ary)

  end

  def self.form(algorithm)
    string_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "string"}

    form_string = "
    <div ng-init='func.args = []'></div>
    <select ng-model='func.args[0]'>
      <option>select</option>"
      string_dimensions.each do |sd|  
        form_string += "<option>#{sd[:name]}</option>"
      end
    form_string += "
    </select>            
    <select ng-model='func.args[1]' >
      <option>select</option>"
      string_dimensions.each do |sd|  
        form_string += "<option>#{sd[:name]}</option>"
      end
    form_string += "
    </select>"

    form_string
  end


  def self.translate_form_args(args_from_form)
    translated_args = [args_from_form["dimension1"]]
    if args_from_form["dimension2"] && args_from_form["dimension2"] != "select"
      translated_args << args_from_form["dimension2"]
    end
    translated_args
  end

  
  def self.group_by_dimension(ary, dimension)
    with_benchmark("group by dimension: ") do 
      dimensions_to_remove = []
      ary[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || key.to_s == dimension.to_s
      end 
      ary = remove_dimensions(ary, dimensions_to_remove)

      all_values = ary.map{|row| row[dimension.to_sym]}.uniq
      row_groups = group_rows(ary, dimension, all_values)
      summed_array = []
      row_groups.each {|row_group| summed_array << sum_rows(row_group)}
      ap summed_array
      summed_array
    end
  end

  def self.group_by_dimensions(ary, dimensions)  #for only two dimensions number_of_rows
    if dimensions.length == 2
      group_by_two_dimensions(ary, dimensions)
    elsif dimensions.length == 1
      group_by_dimension(ary, dimensions[0])
    else
      raise "Invalid arguments, must include one or two dimensions in array form"
    end
  end

  def self.group_by_two_dimensions(ary, dimensions)
     dimensions_to_remove = []
      ary[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || dimensions.include?(key.to_s)
      end
      ary = remove_dimensions(ary, dimensions_to_remove)

      grouping_array = []
      dimensions.each do |dim|
        dim_values = ary.map{|row| row[dim.to_sym]}.uniq
        grouping_array << {dimension: dim, values: dim_values}
      end

      summed_array = []
      row_groups = two_dimension_group_rows(ary, grouping_array)
      row_groups.each do |row_group| 
        summed_row = sum_rows(row_group)
        summed_array << summed_row unless summed_row == []
      end
      summed_array
  end

  def self.remove_dimensions(ary, dimensions=[])
    ary.each do |row|
      row.delete_if {|k,v| dimensions.include? k}
    end
  end


end
