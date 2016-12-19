// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require tether/dist/js/tether
//= require bootstrap/dist/js/bootstrap.min
//= require bootstrap-toggle/js/bootstrap-toggle.min
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require_tree .

NProgress.configure({
  showSpinner: false,
  ease: 'ease',
  speed: 500
});

var ready = function() {
  $('[data-toggle="tooltip"]').tooltip();
  $('[type="checkbox"][data-toggle="toggle"]').bootstrapToggle();

  // Scroll if tab selected
  $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
    var scrollmem = $('body').scrollTop();
    window.location.hash = this.hash;
    $('html,body').scrollTop(scrollmem);
  });
};

$(document).on('turbolinks:load', ready);

$(window).on('turbolinks:load hashchange', function() {
  // Activate tab if applicable
  var hash = window.location.hash;
  hash && $('ul.nav-tabs a[href="' + hash + '"]').tab('show');
});
