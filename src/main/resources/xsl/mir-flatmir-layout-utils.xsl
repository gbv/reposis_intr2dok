<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
    xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
    xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
    exclude-result-prefixes="i18n mcrver mcrxsl">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />
  <xsl:param name="piwikID" select="'0'" />

  <xsl:template name="mir.navigation">

    <div id="header_box" class="clearfix container">
      <div id="options_nav_box" class="mir-prop-nav">
        <nav>
          <ul class="nav navbar-nav float-right">
            <xsl:call-template name="mir.loginMenu" />
          </ul>
        </nav>
      </div>
      <div id="project_logo_box">
        <a href="{concat($WebApplicationBaseURL,substring($loaded_navigation_xml/@hrefStartingPage,2),$HttpSession)}"
           class="">
          <img src="{$WebApplicationBaseURL}content/images/logo25/Logo_intRechtDok-rot.svg" title="IntR2Dok - Logo" class="intR2Dok_logo_small" alt="&lt;intR&gt;²Dok [§]" />
          <!-- span id="logo_modul">Repositorium</span -->
          <!-- span id="logo_slogan">mods institutional repository</span -->
        </a>
      </div>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="mir-main-nav bg-primary">
      <div class="container">
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">

          <button
                  class="navbar-toggler"
                  type="button"
                  data-toggle="collapse"
                  data-target="#mir-main-nav-collapse-box"
                  aria-controls="mir-main-nav-collapse-box"
                  aria-expanded="false"
                  aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>

          <div id="mir-main-nav-collapse-box" class="collapse navbar-collapse mir-main-nav__entries">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
              <xsl:for-each select="$loaded_navigation_xml/menu">
                <xsl:choose>
                  <!-- Ignore some menus, they are shown elsewhere in the layout -->
                  <xsl:when test="@id='main'"/>
                  <xsl:when test="@id='brand'"/>
                  <xsl:when test="@id='below'"/>
                  <xsl:when test="@id='user'"/>
                  <xsl:when test="@id='social'"/>
                  <xsl:when test="@id='rights'"/>
                  <xsl:when test="@id='technical'"/>
                  <xsl:when test="mcrxsl:isCurrentUserGuestUser() and @id='publish'"/>
                  <xsl:otherwise>
                    <xsl:apply-templates select="."/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:if test="mcrxsl:isCurrentUserGuestUser()">
                <li class="nav-item">
                   <a class="nav-link" href="{$WebApplicationBaseURL}authorization/new-author.xed">
                     Registrieren
                   </a>
                 </li>
               </xsl:if>
              <xsl:call-template name="mir.basketMenu" />
            </ul>

            <form
                    action="{$WebApplicationBaseURL}servlets/solr/find"
                    class="searchfield_box form-inline my-2 my-lg-0"
                    role="search">
              <input
                      name="condQuery"
                      placeholder="{i18n:translate('mir.navsearch.placeholder')}"
                      class="form-control search-query"
                      id="searchInput"
                      type="text"
                      aria-label="Search" />
              <xsl:choose>
                <xsl:when test="contains($isSearchAllowedForCurrentUser, 'true')">
                  <input name="owner" type="hidden" value="createdby:*" />
                </xsl:when>
                <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">
                  <input name="owner" type="hidden" value="createdby:{$CurrentUser}" />
                </xsl:when>
              </xsl:choose>
              <button type="submit" class="btn btn-secondary btn-flat my-2 my-sm-0">
                <i class="fas fa-search"></i>
              </button>
            </form>

          </div>

        </nav>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.jumbotwo">
    <!-- show only on startpage -->
    <xsl:if test="//div/@class='jumbotwo'">
      <div class="jumboHome">
        <div class="container">
          <div class="row">
            <div class="col-5">
              <h1><img alt="&lt;intR>²Dok [§]" class="intR2Dok_logo" title="IntR2Dok - Logo" src="{$WebApplicationBaseURL}content/images/logo25/Logo_intRechtDok-rot.svg" /></h1>
            </div>
            <div class="col-5">
              <h2>Fachinformationsdienst für <br />internationale und interdisziplinäre<br /> Rechtsforschung</h2>
            </div>
            <div class="col-2 intR2Dok_dini">
              <a href="http://www.dini.de/dini-zertifikat/" class="float-right intR2Dok_dini"><img src="{$WebApplicationBaseURL}content/images/dini_zertifikat_2016.svg" alt="Logo DINI-Zertifikat 2016" height="150" /></a>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container">
      <div class="row">
        <div class="col-md-2 col-6 col-sm-3">
          <h4>Über uns</h4>
          <ul class="internal_links">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='brand']/*" />
          </ul>
        </div>
        <div class="col-md-2 col-6 col-sm-3">
          <h4>Soziales</h4>
          <ul class="social_links">
            <li><a href="http://twitter.com/vifarecht"><img src="{$WebApplicationBaseURL}content/images/logo_twitter.png" alt="Twitter-Logo" style="margin-right:5px;float:left;" />#vifarecht</a></li>
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='social']/*" />
          </ul>
        </div>
        <div class="col-md-2 col-6 col-sm-3">
          <h4>Rechtliches</h4>
          <ul class="internal_links">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='rights']/*" />
          </ul>
        </div>
        <div class="col-md-2 col-6 col-sm-3">
          <h4>Technisches</h4>
          <ul class="internal_links">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='technical']/*" />
          </ul>
        </div>
        <div class="col-md-4 col-6 col-sm-3">
          <h4>Institutionelles</h4>
          <ul class="internal_links institutions">
            <li id="vfr"><a href="https://vifa-recht.de/"><img src="{$WebApplicationBaseURL}content/images/logo25/Logo_intRecht-weiss.png" alt="ViFa-Recht-Logo" /></a></li>
            <li class="even_entry"><a id="sbb" href="https://www.staatsbibliothek-berlin.de/"><img src="{$WebApplicationBaseURL}content/images/logo_sbb.png" alt="Logo der Staatsbibliothek zu Berlin" /></a></li>
            <li><a id="dfg" href="https://dfg.de/"><img src="{$WebApplicationBaseURL}content/images/logo_dfg.png" alt="DFG-Logo" /></a></li>
            <li class="even_entry"><a id="oa" href="https://www.open-access.net/"><img src="{$WebApplicationBaseURL}content/images/logo_oa.svg" alt="OpenAccess-Logo" width="89px" /></a></li>
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.powered_by">
    <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
    <div id="powered_by">
      <a href="https://www.mycore.de">
        <img src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_small_invert.png" title="{$mcr_version}" alt="powered by MyCoRe" />
      </a>
    </div>
    <script type="text/javascript" src="{$WebApplicationBaseURL}js/jquery.cookiebar.js"></script>
    <!-- Piwik -->
    <xsl:if test="$piwikID &gt; 0">
      <script type="text/javascript">
            var _paq = _paq || [];
            _paq.push(['setDoNotTrack', true]);
            _paq.push(['trackPageView']);
            _paq.push(['enableLinkTracking']);
            (function() {
              var u="https://matomo.gbv.de/";
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
      <noscript><p><img src="https://matomo.gbv.de/piwik.php?idsite={$piwikID}" style="border:0;" alt="matomo" /></p></noscript>
    </xsl:if>
    <!-- End Piwik Code -->
  </xsl:template>
</xsl:stylesheet>
