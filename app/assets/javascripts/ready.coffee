$(document).on "turbolinks:load", ->
  Materialize.updateTextFields();
  $('select').material_select();
  $("#slide_nav").sideNav();
  $('select').material_select();
  $('.dropdown-button').dropdown();
  $ ->
    url = window.location.pathname
    activePage = url.substring(url.lastIndexOf('/') + 1)
    $('.side-nav li a').each ->
      currentPage = @href.substring(@href.lastIndexOf('/') + 1)
      if activePage == currentPage
        $(this).parent().addClass 'active'
      return
    return