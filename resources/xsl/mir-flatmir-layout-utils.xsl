<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:actionmapping="xalan://org.mycore.wfc.actionmapping.MCRURLRetriever" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" exclude-result-prefixes="actionmapping">
  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />
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
          <form action="{$WebApplicationBaseURL}servlets/solr/find?qry={0}" class="navbar-form navbar-left pull-right" role="search">
            <div class="form-group">
              <button class="btn btn-flat" type="submit"><i class="fa fa-search"></i></button>
              <input id="searchInput" class="form-control search-query" placeholder="Suchbegriff eingeben" name="qry" type="text" />
            </div>
          </form>
        </div>

        <nav class="collapse navbar-collapse mir-main-nav-entries">
          <ul class="nav navbar-nav pull-left">
            <!-- xsl:apply-templates select="$loaded_navigation_xml/menu[@id='search']" / -->
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='browse']" />
            <xsl:choose>
              <xsl:when test="mcrxsl:isCurrentUserInRole('admin') or mcrxsl:isCurrentUserInRole('editor')">
                <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='publish']" />
              </xsl:when>
              <xsl:otherwise>
                <li id="publish">
                  <a href="{$WebApplicationBaseURL}servlets/MCRActionMappingServlet/mods/create">
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
</xsl:stylesheet>