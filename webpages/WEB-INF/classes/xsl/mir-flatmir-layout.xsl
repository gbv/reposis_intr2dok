<?xml version="1.0" encoding="utf-8"?>
  <!-- ============================================== -->
  <!-- $Revision$ $Date$ -->
  <!-- ============================================== -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:basket="xalan://org.mycore.frontend.basket.MCRBasketManager" xmlns:mcr="http://www.mycore.org/" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:actionmapping="xalan://org.mycore.wfc.actionmapping.MCRURLRetriever" xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" exclude-result-prefixes="xlink basket actionmapping mcr mcrver mcrxsl i18n">
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" omit-xml-declaration="yes" media-type="text/html"
    version="5" />
  <xsl:strip-space elements="*" />
  <xsl:include href="resource:xsl/mir-flatmir-layout-utils.xsl"/>
  <!-- Various versions -->
  <xsl:variable name="bootstrap.version" select="'3.1.1'" />
  <xsl:variable name="bootswatch.version" select="$bootstrap.version" />
  <xsl:variable name="fontawesome.version" select="'4.0.3'" />
  <xsl:variable name="jquery.version" select="'1.11.0'" />
  <xsl:variable name="jquery.migrate.version" select="'1.2.1'" />
  <!-- End of various versions -->
  <xsl:variable name="PageTitle" select="/*/@title" />
  <xsl:template match="/site">
    <html lang="{$CurrentLang}" class="no-js">
      <head>
        <meta charset="utf-8" />
        <title>
          <xsl:value-of select="$PageTitle" />
        </title>
        <xsl:comment>
          Mobile viewport optimisation
        </xsl:comment>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="//netdna.bootstrapcdn.com/font-awesome/{$fontawesome.version}/css/font-awesome.min.css" rel="stylesheet" />
        <link href="{$WebApplicationBaseURL}mir-flatmir-layout/css/layout.css" rel="stylesheet" />
        <script type="text/javascript" src="//code.jquery.com/jquery-{$jquery.version}.min.js"></script>
        <script type="text/javascript" src="//code.jquery.com/jquery-migrate-{$jquery.migrate.version}.min.js"></script>
      </head>

      <body>

        <header>
            <xsl:call-template name="mir.navigation" />
        </header>

        <!-- show only on startpage -->
        <xsl:if test="//div/@class='container jumbotwo'">
          <div class="jumbotron">
             <div class="container">
               <h1><img src="images/logo_intR2Dok.png" title="IntR2Dok - Logo" class="intR2Dok_logo" alt="&lt;intR&gt;²Dok [§]" /></h1>
               <h2>Fachinformationsdienst für internationale und interdisziplinäre Rechtsforschung</h2>
             </div>
          </div>
        </xsl:if>

        <div class="container" id="page">
          <div class="row">
            <div class="col-md-12" id="main_content">
              <xsl:call-template name="print.writeProtectionMessage" />
              <xsl:choose>
                <xsl:when test="$readAccess='true'">
                  <xsl:copy-of select="*" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="printNotLoggedIn" />
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </div>

        <footer class="panel-footer flatmir-footer" role="contentinfo">
          <div class="container">
            <div class="row">
              <div class="col-md-3">
                <h4>Über uns</h4>
                  <ul class="internal_links">
                    <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='brand']/*" />
                  </ul>
                </div>
                <div class="col-md-2">
                  <h4>Rechtliches</h4>
                  <ul class="internal_links">
                    <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='rights']/*" />
                  </ul>
                </div>
                <div class="col-md-2">
                  <h4>Technisches</h4>
                  <ul class="internal_links">
                    <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='technical']/*" />
                  </ul>
                </div>
                <div class="col-md-2">
                  <h4>Soziales</h4>
                  <ul class="social_links">
                      <li><a href="http://twitter.com/vifarecht"><button type="button" class="social_icons social_icon_tw"></button>Twitter</a></li>
                      <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='social']/*" />
                  </ul>
                </div>
                <div class="col-md-3">
                  <h4>Institutionelles</h4>
                  <ul class="internal_links">
                    <li><a href="http://www.staatsbibliothek-berlin.de/"><img src="{$WebApplicationBaseURL}/content/images/SBB_Logo.png" style="height:15px;float:left;" /> SBB</a></li>
                    <li><a href="http://dfg.de/"><img src="{$WebApplicationBaseURL}/content/images/dfg_logo_grey.jpg" style="height:15px;float:left;" /> DFG</a></li>
                    <li><a href="http://www.open-access.net/"><img src="{$WebApplicationBaseURL}/content/images/OpenAccess_Logo_grey.jpg" style="height:15px;float:left;" /> Open Access</a></li>
                  </ul>
                </div>
            </div>
            <div class="row">
              <div id="powered_by"  class="pull-right"><a href="http://www.mycore.de"><img src="{$WebApplicationBaseURL}mir-flatmir-layout/images/mycore_logo_small_invert.png" /></a></div>
              <div id="mcr_version"><xsl:value-of select="concat('MyCoRe ',mcrver:getCompleteVersion())" /></div>
            </div>
          </div>
        </footer>

        <script type="text/javascript">
          <!-- Bootstrap & Query-Ui button conflict workaround  -->
          if (jQuery.fn.button){jQuery.fn.btn = jQuery.fn.button.noConflict();}
        </script>
        <script type="text/javascript" src="//netdna.bootstrapcdn.com/bootstrap/{$bootstrap.version}/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="{$WebApplicationBaseURL}js/mir/base.js"></script>
<!--         <script src="{$WebApplicationBaseURL}mir-flatmir-layout/datepicker/js/bootstrap-datepicker.js"></script> -->
        <script>
          $( document ).ready(function() {
            $('.overtext').tooltip();
    //        $('#start_date').datepicker();
    //        $('#end_date').datepicker();
          });
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>