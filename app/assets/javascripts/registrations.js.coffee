# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

camp_fields = ['#registration_phone_number', '#registration_quantity', '#registration_morning_camp', '#registration_afternoon_camp', '#registration_am_extended', '#registration_lunch_extended_hours', '#registration_pm_extended_hours']
total = 0
discount = 0

update_discount = (event) ->
  $.get('/discount_codes.json?id='+$('#registration_living_social_code').val()).success (data) ->
    switch data.seats
      when null
        discount = 0
      when 'one'
        discount = 1
      when 'two'
        discount = 2
    validate_form()


validate_form = (event) ->
  phone_selector = $('#registration_phone_number')
  update_total(event)
  if phone_selector.val()
    $('.stripe-button-el').show()
  else
    $('.stripe-button-el').hide()

set_total = (sub_total) ->
  if sub_total < 0
    total = 0
  else
    total = sub_total

update_total = (event) ->
  option_total = 0
  camp_fields.forEach (field) ->
    option_total += $(field).data('price') if $(field).prop('checked') is true
  if quantity = $('#registration_quantity').val()
    if option_total > 0
      set_total option_total * (quantity - discount)
    else
      set_total $('#event_cost').val() * (quantity - discount || 0)
  else
    set_total 0
  $('#total').html('Total: $ ' + total + '.00')

$(document).ready ->
  $('.stripe-button-el').hide()
  camp_fields.forEach (field) -> 
    $(field).change validate_form
    $(field).keypress validate_form
  $('#registration_living_social_code').keypress update_discount
  $('#registration_living_social_code').change update_discount
  validate_form()
