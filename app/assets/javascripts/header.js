/*
 * header.js - Header
 *
 * Florian Dejonckheere <florian@floriandejonckheere.be>
 *
 * */

var ready = function() {
  $('[data-toggle="dropdown"]').click(function(ev) {
    $($(ev.currentTarget).attr('data-target')).toggle();
  });
};

$(document).ready(ready)
$(document).on('page:load', ready)
