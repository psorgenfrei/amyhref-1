// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.pageless
//= require foundation
//= require jquery.hotkeys
//= require jquery.keyboard-navigation
//= require turbolinks
//= require_tree .

$(document).on('ready page:load', function(event) {
  Turbolinks.enableProgressBar();

  // init jquey navigation
  $('.links').keyboardNavagation();

  //$('#links a').embedly({ key: '6863f842d9c241e192dad41cab69138c' });
  //var rendered_cards = 0;
  //var total_cards = $('a.embedly-card').length;
  //embedly('on', 'card.rendered', function(iframe){
  //  rendered_cards = rendered_cards + 1;
  //  if (rendered_cards >= total_cards) {
  //    $('#overlay').remove();
  //  }
  //});
});

// j - down 
$(document).bind('keydown', 'j', function(){
  $('.links').trigger('scrollNext');
});

// k - up
$(document).bind('keydown', 'k', function(){
  $('.links').trigger('scrollPrev');
});

$(function(){ $(document).foundation(); });
