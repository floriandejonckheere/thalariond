/*
 * users.js - Users
 *
 * Florian Dejonckheere <florian@floriandejonckheere.be>
 *
 * */

var ready = function() {
  $('#button-edit-uid').click(function() {
    $('#section-edit-uid').toggle();
    $('#section-show-uid').toggle();
  });

  $('#button-role-add').click(function() {
    return !$('#select-all-roles option:selected').remove().appendTo('#select-user-roles');
  });
  $('#button-role-remove').click(function() {
    return !$('#select-user-roles option:selected').remove().appendTo('#select-all-roles');
  });
};

$(document).ready(ready)
$(document).on('page:load', ready)
