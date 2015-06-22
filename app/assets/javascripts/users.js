/*
 * users.js - Users
 *
 * Florian Dejonckheere <florian@floriandejonckheere.be>
 *
 * */

var ready = function() {
  $('#button-edit').click(function(ev) {
    if(window.confirm('Are you sure you wish to continue? This will change the ' + $(ev.currentTarget).attr('data-property') + ' for ALL services and may have unintended consequences! Consult your system administrator for further advice.')) {
      $('#section-edit').toggle();
      $('#section-show').toggle();
    }
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
