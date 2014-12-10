<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="xsl mods"
>

<xsl:include href="mods2dc.xsl" />
<xsl:include href="mods2record.xsl" />
<xsl:include href="mods-utils.xsl" />

<xsl:template match="mycoreobject" mode="metadata">
  <xsl:for-each select="//mods:mods">
    <oai_dc:dc
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/  http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
      <xsl:apply-templates/>
    </oai_dc:dc>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
