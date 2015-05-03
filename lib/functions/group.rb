module Group

  def self.execute(ary, dimensions, dataset_dimensions)
    calculated_dimensions = dataset_dimensions.select{|dd| dd["retrieve_from_from"] == "calculation"}
    
    dimensions.each do |dim|
      if calculated_dimensions.map{|dd| dd["name"]}.include? dim["name"]
        ary = ReportCruncher.add_calculated_dimension(ary, dimension)
      end
    end

    symbol_ary = convert_to_symbols(ary)
    
    with_benchmark("with symbol keys") do 
      100.times do |i|
        x = symbol_ary
        group_by_dimensions(x, dimensions, dataset_dimensions)
      end
    end

    with_benchmark("with string keys") do 
      100.times do |i|
        x = ary
        group_by_dimensions(x, dimensions, dataset_dimensions)
        x
      end
    end
      
  end



  def self.form(algorithm)
    string_dimensions = algorithm.dimensions.select{|dim| dim[:data_type] == "string"}

    form_string = "
    <div style='display:inline' ng-init='func.args == null ? func.args = [] : null'></div>
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
  
  def self.group_by_dimension(ary, dimension, dataset_dimensions)
      start_time = Time.now
      dimensions_to_remove = []
      ary[0].each do |key, value|
        dimensions_to_remove << key unless value.is_a?(Numeric) || key.to_s == dimension.to_s
      end 
      ary = remove_dimensions(ary, dimensions_to_remove)

      all_values = ary.map{|row| row[dimension]}.uniq
      row_groups = group_rows(ary, dimension, all_values)

      summed_array = []
      row_groups.each {|row_group| summed_array << sum_rows(row_group)}

      summed_array
  end

  def self.group_by_dimensions(ary, dimensions, dataset_dimensions)  #for only two dimensions number_of_rows
    if dimensions.length == 2
      group_by_two_dimensions(ary, dimensions, dataset_dimensions)
    elsif dimensions.length == 1
      group_by_dimension(ary, dimensions[0], dataset_dimensions)
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
        dim_values = ary.map{|row| row[dim]}.uniq
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

  def self.group_rows(rows, dimension, values)
    row_groups = Hash[values.map {|k| [k, []]}]
    rows.each do |row|
      row_groups[row[dimension]] << row if row_groups[row[dimension]]
    end

    row_groups.values
  end

  def self.two_dimension_group_rows(rows, grouping_array) #for only two dimensions now
    row_groups = Set.new
    outer_dimension = grouping_array[0][:dimension]
    inner_dimension = grouping_array[1][:dimension]
    grouping_array[0][:values].each do |outer_value|
      grouping_array[1][:values].each do |inner_value|
        row_groups << rows.select {|row| row[outer_dimension] == outer_value && row[inner_dimension] == inner_value}
      end
    end
    row_groups
  end

  def self.sum_rows(row_group)
    if row_group && row_group.length > 0  
      sum = row_group[0]
      row_group[1..-1].each do |row|
        row.map do |k, v|
          sum[k] += row[k].to_i if sum[k].is_a? Integer
          sum[k] = sum[k].to_f + row[k].to_f if k == "cost"
        end
      end
      sum.each {|k, v| sum[k] = v.round(2) if v.is_a?(Float)}
      # sum["cpc"] = (sum["cost"] / sum["clicks"].to_f).round(2)
      sum
    else
      []
    end
  end

  def self.with_benchmark(annotation)
    start = Time.now
      result = yield
    puts "elapsed group time #{annotation}: " + (Time.now - start).to_s
    result
  end

  def self.convert_to_symbols(ary)
    ary.map do |row|
      row.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    end
  end

end
