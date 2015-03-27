# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
	truncate_form = (number) ->  number+") <strong>Truncate: </strong> number of rows <input style='width:75px' type='number' /> <br /><br />"
	filter_form = (number) -> number+") <strong>Filter:</strong>
			<input type='hidden' name='crunch_algorithm[functions]["+number+"][name]' value='filter' />
			<input type='hidden' name='crunch_algorithm[functions]["+number+"][new]' value='true' />
			<select name='crunch_algorithm[functions]["+number+"][args][dimension1]'>dimension1
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select name='crunch_algorithm[functions]["+number+"][args][comparison1]'>direction1
				<option>></option>
				<option>=</option>
				<option><</option>
			</select>
			<input name='crunch_algorithm[functions]["+number+"][args][value1]' style='width:75px' type='number'></input>
			<span>AND </span>
			<select name='crunch_algorithm[functions]["+number+"][args][dimension2]'>dimension2
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select name='crunch_algorithm[functions]["+number+"][args][comparison2]'>direction2
				<option>></option>
				<option>=</option>
				<option><</option>
			<span>Value</span>
			<input name='crunch_algorithm[functions]["+number+"][args][value2]' style='width:75px' type='number'></input>
			</select> <br /><br />"
	group_form = (number) -> number+") <strong>Group:</strong>
			<select>dimension1
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<span> AND </span>
			<select>dimension2
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select><br /><br />"
	sorting_form = (number) -> number+") <strong>Sort:</strong>
			<select>dimension1
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select>direction1
				<option>descending</option>
				<option>ascending</option>
			</select>
			<span> AND </span>
			<select>dimension2
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select>direction2
				<option>descending</option>
				<option>ascending</option>
			</select> <br /><br />"
	num_functions = $('.function-setting').length
	crunchAlgorithmId = $('#functions').data('crunch-alg-id')
	$('#function-selector').on "change", ->
	  value = $(this).val()
	  if value != 'select'
	      num_functions += 1
	  if value == 'truncate'
	      $('#functions').append(truncate_form(num_functions))
	  if value == 'sort'
	      $('#functions').append(sorting_form(num_functions))	  
	  if value == 'filter'
	      $('#functions').append(filter_form(num_functions))	  
	  if value == 'group'
	      $('#functions').append(group_form(num_functions))
      $('#functions').append($('#function-selector'))
      $('#function-selector').val('select') 
