
$﻿(document).ready(function() {

  // replace placeholder USERNAME with username
  var userID = $("#currentUser strong").html();
  var newHref = 'https://intr2dok.vifa-recht.de/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://intr2dok.vifa-recht.de/servlets/solr/select?q=createdby:USERNAME']").attr('href', newHref);

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
  
  $.cookieBar({
    fixed: true,
    message: 'Auf den Seiten von &lt;intR&gt;²Dok werden zur Erhöhung des Bedienungskomforts Cookies verwendet. Mit der Nutzung dieser Seiten erklären Sie, dass Sie die rechtlichen Hinweise gelesen haben und akzeptieren.',
    acceptText: 'Akzeptieren',
    policyButton: true,
    policyText: 'Hinweise zum Datenschutz',
    policyURL: '/content/rights/privacy.xml',
    expireDays: 1,
    zindex: '356',
    domain: 'intr2dok.vifa-recht.de',
    referrer: 'intr2dok.vifa-recht.de'
  });

  var v1 = jQuery(".nav li a:contains('Verfassungsblog')");
  v1.on("click", function(e){ e.preventDefault(); openWpImport("Verfassungsblog"); return false; });
  var v2 = jQuery(".nav li a:contains('Völkerrechtsblog')");
  v2.on("click", function(e){ e.preventDefault(); openWpImport("Völkerrechtsblog"); return false;  });
  var v3 = jQuery(".nav li a:contains('JuWissBlog')");
  v3.on("click", function(e){ e.preventDefault(); openWpImport("JuWissBlog"); return false;  });
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

function openWpImport(config) {
    var req = new XMLHttpRequest();
    req.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var responseObj = JSON.parse(this.response);
	    var link = document.createElement('a');
    	    link.href = webApplicationBaseURL + "wordpressimport/#/token/" + config + "/" + responseObj.token_type + " " + (responseObj.access_token);
            link.target = "_blank";
	    document.body.appendChild(link);
	    link.click();
	    document.body.removeChild(link);
        } else if (this.readyState == 4) {
            alert("Fehler!");
            console.error(this.status + "-" + this.statusText);
        }
    };
    req.open("GET", webApplicationBaseURL + "rsc/jwt", false);
    req.send();
};


