# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
	$.ajaxSetup({async:false})
	num_functions = $('.function-setting').length
	crunchAlgorithmId = $('#functions').data('crunch-alg-id')
	$('#function-selector').on "change", ->
	  value = $(this).val()
	  if value != 'select'
	      num_functions += 1
	  	  $.get("get_form.html?func="+value+"&n="+num_functions, (data) -> $('#functions').append(data))
      $('#functions').append($('#function-selector'))
      $('#function-selector').val('select') 
