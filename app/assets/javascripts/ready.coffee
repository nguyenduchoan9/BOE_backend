$(document).on "turbolinks:load", ->
  Materialize.updateTextFields();
  $('select').material_select();
  $("#slide_nav").sideNav();
  $('#data_tables').dataTable();
  $('select').material_select();