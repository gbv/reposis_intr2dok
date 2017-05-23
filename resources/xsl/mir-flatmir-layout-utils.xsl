<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
    xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
    exclude-result-prefixes="mcrver mcrxsl">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />
  <xsl:param name="piwikID" select="'0'" />

  <xsl:template name="mir.navigation">

    <div id="header_box" class="clearfix container">
      <div id="options_nav_box" class="mir-prop-nav">
        <nav>
          <ul class="nav navbar-nav pull-right">
            <xsl:call-template name="mir.loginMenu" />
          </ul>
        </nav>
      </div>
      <div id="project_logo_box">
        <a href="{concat($WebApplicationBaseURL,substring($loaded_navigation_xml/@hrefStartingPage,2),$HttpSession)}"
           class="">
          <img src="{$WebApplicationBaseURL}content/images/logo_intR2Dok_small.png" title="IntR2Dok - Logo" class="intR2Dok_logo_small" alt="&lt;intR&gt;²Dok [§]" />
          <!-- span id="logo_modul">Repositorium</span -->
          <!-- span id="logo_slogan">mods institutional repository</span -->
        </a>
      </div>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="navbar navbar-default mir-main-nav">
      <div class="container">

        <div class="navbar-header">
          <button class="navbar-toggle" type="button" data-toggle="collapse" data-target=".mir-main-nav-entries">
            <span class="sr-only"> Toggle navigation </span>
            <span class="icon-bar">
            </span>
            <span class="icon-bar">
            </span>
            <span class="icon-bar">
            </span>
          </button>
        </div>

        <div class="searchfield_box">
          <form action="{$WebApplicationBaseURL}servlets/solr/find?q={0}" class="navbar-form navbar-left pull-right" role="search">
            <div class="form-group">
              <button class="btn btn-flat" type="submit"><i class="fa fa-search"></i></button>
              <input id="searchInput" class="form-control search-query" placeholder="Suchbegriff eingeben" name="q" type="text" />
            </div>
          </form>
        </div>

        <nav class="collapse navbar-collapse mir-main-nav-entries">
          <ul class="nav navbar-nav pull-left">
            <!-- xsl:apply-templates select="$loaded_navigation_xml/menu[@id='search']" / -->
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='browse']" />
            <xsl:choose>
              <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">
                <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='publish']" />
              </xsl:when>
              <xsl:otherwise>
                <li id="publish">
                  <a href="{$WebApplicationBaseURL}authorization/new-author.xed">
                    <xsl:choose>
                      <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">Publizieren</xsl:when>
                      <xsl:otherwise>Registrieren</xsl:otherwise>
                    </xsl:choose>
                  </a>
                </li>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="mir.basketMenu" />
          </ul>
        </nav>

      </div><!-- /container -->
    </div>
  </xsl:template>

  <xsl:template name="mir.jumbotwo">
    <!-- show only on startpage -->
    <xsl:if test="//div/@class='jumbotwo'">
      <div class="jumboHome">
        <div class="container">
          <div class="col-md-6">
            <h1><img alt="&lt;intR>²Dok [§]" class="intR2Dok_logo" title="IntR2Dok - Logo" src="images/logo_intR2Dok.png" /></h1>
          </div>
          <div class="col-md-6">
            <h2>Fachinformationsdienst für <br />internationale und interdisziplinäre<br /> Rechtsforschung</h2>
          </div>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container">
      <div class="row">
        <div class="col-md-2 col-xs-6 col-sm-3">
          <h4>Über uns</h4>
          <ul class="internal_links">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='brand']/*" />
          </ul>
        </div>
        <div class="col-md-2 col-xs-6 col-sm-3">
          <h4>Soziales</h4>
          <ul class="social_links">
            <li><a href="http://twitter.com/vifarecht"><img src="{$WebApplicationBaseURL}/content/images/logo_twitter.png" style="margin-right:5px;float:left;" />#vifarecht</a></li>
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='social']/*" />
          </ul>
        </div>
        <div class="col-md-2 col-xs-6 col-sm-3">
          <h4>Rechtliches</h4>
          <ul class="internal_links">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='rights']/*" />
          </ul>
        </div>
        <div class="col-md-2 col-xs-6 col-sm-3">
          <h4>Technisches</h4>
          <ul class="internal_links">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='technical']/*" />
          </ul>
        </div>
        <div class="col-md-4 col-xs-6 col-sm-3">
          <h4>Institutionelles</h4>
          <ul class="internal_links institutions">
            <li><a id="vfr" href="http://vifa-recht.de/"><img src="{$WebApplicationBaseURL}/content/images/logo-vfr.png" /></a></li>
            <li class="even_entry"><a id="sbb" href="http://www.staatsbibliothek-berlin.de/"><img src="{$WebApplicationBaseURL}/content/images/logo_sbb.png" /></a></li>
            <li><a id="dfg" href="http://dfg.de/"><img src="{$WebApplicationBaseURL}/content/images/logo_dfg.png" /></a></li>
            <li class="even_entry"><a id="oa" href="https://www.open-access.net/"><img src="{$WebApplicationBaseURL}/content/images/logo_oa.svg" /></a></li>
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.powered_by">
    <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
    <div id="powered_by">
      <a href="http://www.mycore.de">
        <img src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_small_invert.png" title="{$mcr_version}" alt="powered by MyCoRe" />
      </a>
    </div>
    <!-- Piwik -->
    <xsl:if test="$piwikID &gt; 0">
      <script type="text/javascript">
            var _paq = _paq || [];
            _paq.push(['setDoNotTrack', true]);
            _paq.push(['trackPageView']);
            _paq.push(['enableLinkTracking']);
            (function() {
              var u="https://piwik.gbv.de/";
              var objectID = '<xsl:value-of select="//site/@ID" />';
              if(objectID != "") {
                _paq.push(["setCustomVariable",1, "object", objectID, "page"]);
              }
              _paq.push(['setTrackerUrl', u+'piwik.php']);
              _paq.push(['setSiteId', '<xsl:value-of select="$piwikID" />']);
              _paq.push(['setDownloadExtensions', '7z|aac|arc|arj|asf|asx|avi|bin|bz|bz2|csv|deb|dmg|doc|exe|flv|gif|gz|gzip|hqx|jar|jpg|jpeg|js|mp2|mp3|mp4|mpg|mpeg|mov|movie|msi|msp|odb|odf|odg|odp|ods|odt|ogg|ogv|pdf|phps|png|ppt|qt|qtm|ra|ram|rar|rpm|sea|sit|tar|tbz|tbz2|tgz|torrent|txt|wav|wma|wmv|wpd|z|zip']);
              var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
              g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
            })();
      </script>
      <noscript><p><img src="https://piwik.gbv.de/piwik.php?idsite={$piwikID}" style="border:0;" alt="" /></p></noscript>
    </xsl:if>
    <!-- End Piwik Code -->
  </xsl:template>
</xsl:stylesheet>