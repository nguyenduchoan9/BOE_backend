$(document).on "turbolinks:load", ->
  $('.modal').modal();
  $('#textarea1').trigger('autoresize');
  Materialize.updateTextFields();
  $('select').material_select();
  $("#slide_nav").sideNav();
  $('select').material_select();
  $('.dropdown-button').dropdown();
  data = firebase.database().ref().child('rejectedOrder');
  i = 0;
  data.on 'child_added', (snapshot) ->
    number = firebase.database().ref('/number');
    if snapshot.child('status').val() == 'new'
      number.once('value').then (snapshotnumber) ->
        realNumber = snapshotnumber.val() + 1;
        update = {}
        update['/number'] = realNumber;
        firebase.database().ref().update(update);
        update_status = {}
        update_status['/rejectedOrder/'+snapshot.key+'/status'] = 'old'
        firebase.database().ref().update(update_status);
    if i < 5
      appendNotification snapshot.child('dishName').val();
      i++;
    else if i == 5
      appendNotification snapshot.child('dishName').val();
      $('#notification_dropdown').append('<li style="text-align: center;"><a href="/rejected_order" style="color: blue;">More...</a></li>');
      $('#notification_dropdown li').eq(5).remove();
      i++
    else
      appendNotification snapshot.child('dishName').val();
      $('#notification_dropdown li').eq(5).remove();
      i++
  $ ->
    url = window.location.pathname
    activePage = url.substring(url.lastIndexOf('/') + 1)
    $('.side-nav li a').each ->
      currentPage = @href.substring(@href.lastIndexOf('/') + 1)
      if activePage == currentPage
        $(this).parent().addClass 'active'
      return
    return
