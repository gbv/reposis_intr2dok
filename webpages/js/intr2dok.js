
$﻿(document).ready(function() {

  // spam protection for mails
  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  if ( localStorage.getItem('open_aire_options_are_visible') === "true" ){
    $('#open-aire_box').css('display', 'block');
    $('#open-aire_trigger').removeClass('glyphicon-unchecked');
    $('#open-aire_trigger').addClass('glyphicon-check');
    $('#open-aire_trigger_text').html('handelt es sich um eine Publikation im Rahmen von FP7- oder Horizon2020?');
  } else {
    $('#open-aire_box').css('display', 'none');
    $('#open-aire_trigger').removeClass('glyphicon-check');
    $('#open-aire_trigger').addClass('glyphicon-unchecked');
    $('#open-aire_trigger_text').html('handelt es sich um eine Publikation im Rahmen von FP7- oder Horizon2020?');
  }

  $("#open-aire_trigger_checkbox").click(function(){
    toggleOAOptions();
  });

});


function toggleOAOptions() {
  var duration = 500;
  if ( $('#open-aire_box').is(':visible') ) {
    $('#open-aire_trigger').removeClass('glyphicon-check');
    $('#open-aire_trigger').addClass('glyphicon-unchecked');
    $('#open-aire_box').fadeOut( duration );
    $('#open-aire_trigger_text').html('handelt es sich um eine Publikation im Rahmen von FP7- oder Horizon2020?');
    localStorage.setItem("open_aire_options_are_visible", false);
  } else {
    $('#open-aire_trigger').removeClass('glyphicon-unchecked');
    $('#open-aire_trigger').addClass('glyphicon-check');
    $('#open-aire_box').fadeIn( duration );
    $('#open-aire_trigger_text').html('handelt es sich um eine Publikation im Rahmen von FP7- oder Horizon2020?');
    localStorage.setItem("open_aire_options_are_visible", true);
  }
}