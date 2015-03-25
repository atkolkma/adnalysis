# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
console.log("sdfs")
jQuery ->
	truncate_form = "<strong>Truncate: </strong> number of rows <input style='width:75px' type='number' /> <br /><br />"
	filter_form = "<strong>Filter:</strong>
			<select>dimension1
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select>direction1
				<option>></option>
				<option>=</option>
				<option><</option>
			</select>
			<input  style='width:75px' type='text'></input>
			<span>AND </span>
			<select>dimension2
				<option>select</option>
				<option>clicks</option>
				<option>imps</option>
			</select>
			<select>direction2
				<option>></option>
				<option>=</option>
				<option><</option>
			<span>Value</span>
			<input style='width:75px' type='text'></input>
			</select> <br /><br />"
	group_form = "<strong>Group:</strong>
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
	sorting_form = "
			<strong>Sort:</strong>
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
	$('#function-selector').on "change", ->
	  value = $(this).val()
	  if value == 'truncate'
	      $('#functions').append(truncate_form)
	  if value == 'sort'
	      $('#functions').append(sorting_form)	  
	  if value == 'filter'
	      $('#functions').append(filter_form)	  
	  if value == 'group'
	      $('#functions').append(group_form)
      $('#functions').append($('#function-selector'))
      $('#function-selector').val('select') 
