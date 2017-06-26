$(document).on "turbolinks:load", ->
  Materialize.updateTextFields();
  $('select').material_select();
  $("#slide_nav").sideNav();
  $('select').material_select();
  $('.dropdown-button').dropdown();
  data = firebase.database().ref().child('Phongdemo');
  i = 0;
  data.on 'child_added', (snapshot) ->
    if i < 5
      appendNotification snapshot.child('usename').val();
      i++;
    else if i == 5
      $('#notification_dropdown').append('<li style="text-align: center;"><a href="http://localhost:3000/home" style="color: blue;">More...</a></li>');
      i++
    $('#')

  $ ->
    url = window.location.pathname
    activePage = url.substring(url.lastIndexOf('/') + 1)
    $('.side-nav li a').each ->
      currentPage = @href.substring(@href.lastIndexOf('/') + 1)
      if activePage == currentPage
        $(this).parent().addClass 'active'
      return
    return