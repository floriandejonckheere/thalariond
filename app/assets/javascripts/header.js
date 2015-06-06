/*
 * header.js - Header
 *
 * Florian Dejonckheere <florian@floriandejonckheere.be>
 *
 * */

$(document).ready(function() {
  $('[data-toggle="dropdown"]').click(function(ev) {
    $(ev.currentTarget).siblings('.dropdown-menu').toggle();
  });
})
