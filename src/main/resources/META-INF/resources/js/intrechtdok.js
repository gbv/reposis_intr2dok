
$﻿(document).ready(function() {

  // replace placeholder USERNAME with username
  var userID = $("#currentUser strong").html();
  var newHref = 'https://intrechtdok.de/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://intrechtdok.de/servlets/solr/select?q=createdby:USERNAME']").attr('href', newHref);
  
  var newTestHref = 'https://intrechtdok-test.gbv.de/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://intrechtdok-test.gbv.de/servlets/solr/select?q=createdby:USERNAME']").attr('href', newTestHref);

  // spam protection for mails
  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  $.cookieBar({
    fixed: true,
    message: 'Auf den Seiten von intRechtDok werden zur Erhöhung des Bedienungskomforts Cookies verwendet. Mit der Nutzung dieser Seiten erklären Sie, dass Sie die rechtlichen Hinweise gelesen haben und akzeptieren.',
    acceptText: 'Akzeptieren',
    policyButton: true,
    policyText: 'Hinweise zum Datenschutz',
    policyURL: '/content/rights/privacy.xml',
    expireDays: 1,
    zindex: '356',
    domain: 'intr2dok.vifa-recht.de',
    referrer: 'intr2dok.vifa-recht.de'
  });
});


