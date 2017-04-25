<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:image="https://github.com/Matess/xsltLib" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:file="http://expath.org/ns/file"
  version="2.0" exclude-result-prefixes="#all">
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="metaLibrary.xsl"/>
  <xsl:template match="/">
    <xsl:variable name = "folderURL" select="xs:string('F:\Users\')"/>
    <xsl:variable name = "files" select="file:list($folderURL,false(),'*.*')"/>
    <Images>
    <xsl:for-each select="$files">
      <xsl:variable name = "file" select="concat($folderURL,.)"/>
      <xsl:sequence select="image:findAll($file)"/>
    </xsl:for-each>
    </Images>
  </xsl:template>
</xsl:stylesheet>
