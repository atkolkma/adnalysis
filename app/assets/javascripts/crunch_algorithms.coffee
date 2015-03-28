# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
	num_functions = $('.function-setting').length
	crunchAlgorithmId = $('#functions').data('crunch-alg-id')
	$('#function-selector').on "change", ->
	  value = $(this).val()
	  if value != 'select'
	      num_functions += 1
	  	  $.get("get_form.html?func="+value+"&n="+num_functions, (data) -> $('#functions').append(data))
      $('#function-selector').val('select')
    $('.dynamic-datatype .datatype-selector').on "change", ->
      selector = $(this)
      if selector.find(':selected').data('datatype') == "string"
        console.log(selector.find(':selected').data('datatype'))
        selector.siblings('.string').show()
        selector.siblings('.string').prop('disabled', false)
        selector.siblings('.numeric').hide()
        selector.siblings('.numeric').prop('disabled', true)
      if selector.find(':selected').data('datatype') == "integer" || selector.find(':selected').data('datatype') == "decimal"
        console.log(selector.find(':selected').data('datatype'))
        selector.siblings('.string').hide()
        selector.siblings('.string').prop('disabled', true)
        selector.siblings('.numeric').show()
        selector.siblings('.numeric').prop('disabled', false)
