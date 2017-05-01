<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:image="https://github.com/Matess/metaLibrary" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:file="http://expath.org/ns/file"
  version="2.0" exclude-result-prefixes="#all">
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="metaLibrary.xsl"/>
  <xsl:template match="/">
    <xsl:variable name = "folderURL" select="xs:string('F:\Users\')"/>
    <xsl:sequence select="image:readIMGFolder($folderURL,'*.*')"/>
  </xsl:template>
</xsl:stylesheet>
