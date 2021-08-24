<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:mcri18n="http://www.mycore.de/xslt/i18n"

                version="3.0">

    <xsl:include href="functions/i18n.xsl"/>

    <xsl:param name="WebApplicationBaseURL"/>

    <xsl:template match="/">
        <xsl:variable name="ID" select="/mycoreobject/@ID"/>
        <xsl:variable name="children" select="/mycoreobject/structure/children/child"/>

        <xsl:choose>
            <xsl:when
                    test="/mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:genre[@type='intern' and ends-with(@valueURI, 'mir_genres#blog')]">
                <xsl:variable name="renderedChildren">
                    <xsl:for-each select="$children">
                        <xsl:variable name="doc" select="document(concat('mcrobject:', @xlink:href))"/>
                        <xsl:variable name="ID" select="$doc/mycoreobject/@ID"/>

                        <xsl:variable name="mods"
                                      select="$doc/mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods"/>
                        <xsl:variable name="dateIssued"
                                      select="$mods/mods:originInfo[@eventType='publication']/mods:dateIssued[@encoding='w3cdtf']"/>
                        <xsl:variable name="tokens" select="tokenize($dateIssued,'-')"/>
                        <li class="mir-toc-section-entry" group="{$tokens[1]}" data-sort-1="{$tokens[2]}"
                            data-sort-2="{$tokens[3]}">
                            <div class="row">
                                <div class="col-1">
                                    <xsl:value-of select="concat($tokens[3], '.', $tokens[2])"/>
                                </div>
                                <h4 class="col-11 mir-toc-section-title">
                                    <a href="{$WebApplicationBaseURL}receive/{$ID}">
                                        <xsl:if test="count($mods/mods:titleInfo[1]/mods:nonSort)&gt;0">
                                            <xsl:value-of select="concat($mods/mods:titleInfo[1]/mods:nonSort, ' ')"/>
                                        </xsl:if>
                                        <xsl:value-of select="$mods/mods:titleInfo[1]/mods:title"/>
                                        <xsl:if test="count($mods/mods:titleInfo[1]/mods:subTitle)&gt;0">
                                            <span class="subtitle">
                                                <xsl:text> : </xsl:text>
                                                <xsl:value-of select="$mods/mods:titleInfo[1]/mods:subTitle"/>
                                            </span>
                                        </xsl:if>
                                    </a>
                                </h4>
                            </div>
                        </li>
                    </xsl:for-each>
                </xsl:variable>
                <div>
                    <div class="detail_block">
                        <h3>
                            <xsl:value-of select="mcri18n:translate('mir.metadata.content')"/>
                        </h3>

                        <span style="font-size:smaller;" class="float-right">
                            <a href="#" id="tocShowAll">
                                <xsl:value-of select="mcri18n:translate('mir.abstract.showGroups')"/>
                            </a>
                            <a style="display:none;" href="#" id="tocHideAll">
                                <xsl:value-of select="mcri18n:translate('mir.abstract.hideGroups')"/>
                            </a>
                        </span>
                        <ol class="mir-toc-sections">
                            <xsl:for-each-group select="$renderedChildren/li" group-by="@group">
                                <xsl:sort select="@group" order="descending" />
                                <xsl:variable name="expanded" select="position()=1" />
                                <li class="mir-toc-section">
                                    <xsl:variable name="internID" select="generate-id()"/>
                                    <a aria-controls="{$internID}" aria-expanded="{$expanded}" data-toggle="collapse"
                                       href="#{$internID}"
                                       class="mir-toc-section-toggle collapsed">
                                        <xsl:attribute name="class">
                                            <xsl:choose>
                                                <xsl:when test="not($expanded)">mir-toc-section-toggle collapsed</xsl:when>
                                                <xsl:otherwise>mir-toc-section-toggle</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <span>
                                            <xsl:attribute name="class">
                                                <xsl:text>toggle-collapse fas fa-fw </xsl:text>
                                                <xsl:choose>
                                                    <xsl:when test="$expanded">fa-chevron-down</xsl:when>
                                                    <xsl:otherwise>fa-chevron-right</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                        </span>
                                    </a>
                                    <span class="mir-toc-section-label">
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </span>
                                    <div id="{$internID}">
                                        <xsl:attribute name="class">
                                            <xsl:text>below collapse</xsl:text>
                                            <xsl:if test="$expanded"> show</xsl:if>
                                        </xsl:attribute>
                                        <ul class="mir-toc-section-list">
                                            <xsl:for-each select="current-group()">
                                                <xsl:sort select="@data-sort-1" order="descending"/>
                                                <xsl:sort select="@data-sort-2" order="descending"/>
                                                <xsl:copy-of select="."/>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </li>
                            </xsl:for-each-group>
                        </ol>
                        <script src="{$WebApplicationBaseURL}js/mir/toc-layout.js"/>
                    </div>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div> </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>