
$﻿(document).ready(function() {

  // spam protection for mails
  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  if ( localStorage.getItem('open_aire_options_are_visible') ){
    $('#open-aire_box').css('display', 'block');
    $('#open-aire_trigger').prop('checked', true);
  } else {
    $('#open-aire_box').css('display', 'none');
    $('#open-aire_trigger').prop('checked', false);
  }

  $("#open-aire_trigger").click(function(){
    toggleOAOptions();
  });

});


function toggleOAOptions() {
  var duration = 500;
  if ( $('#open-aire_box').is(':visible') ) {
    $('#open-aire_box').fadeOut( duration );
    $('#open-aire_trigger_text').html(' Optionen einblenden');
    localStorage.setItem("open_aire_options_are_visible", false);
  } else {
    $('#open-aire_box').fadeIn( duration );
    $('#open-aire_trigger_text').html(' Optionen ausblenden');
    localStorage.setItem("open_aire_options_are_visible", true);
  }
}