
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

  var v1 = jQuery("a.dropdown-item:contains('Verfassungsblog')");
  v1.on("click", function(e){ e.preventDefault(); openWpImport("Verfassungsblog"); return false; });
  var v2 = jQuery("a.dropdown-item:contains('Völkerrechtsblog')");
  v2.on("click", function(e){ e.preventDefault(); openWpImport("Völkerrechtsblog"); return false;  });
  var v3 = jQuery("a.dropdown-item:contains('JuWissBlog')");
  v3.on("click", function(e){ e.preventDefault(); openWpImport("JuWissBlog"); return false;  });
  var v4 = jQuery("a.dropdown-item:contains('Rechts|Empirie')");
  v4.on("click", function(e){ e.preventDefault(); openWpImport("Rechts%7CEmpirie:%20Legal%20Empirics%20in%20Europe"); return false;  });
});

function openWpImport(config) {
    var req = new XMLHttpRequest();
    req.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            var responseObj = JSON.parse(this.response);
	    var link = document.createElement('a');
    	    link.href = webApplicationBaseURL + "wordpressimport/#/token/" + config + "/" + responseObj.token_type + " " + (responseObj.access_token);
            link.target = "_blank";
	    document.body.appendChild(link);
	    link.click();
	    document.body.removeChild(link);
        } else if (this.readyState === 4) {
            alert("Fehler!");
            console.error(this.status + "-" + this.statusText);
        }
    };
    req.open("GET", webApplicationBaseURL + "rsc/jwt", false);
    req.send();
};


