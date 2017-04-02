<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:test="http://test.com" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0" exclude-result-prefixes="#all">
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="metaLibrary.xsl"/>
  <xsl:template match="/">
    <xsl:variable name="url" select="xs:string('F:\exif.jpg')"/>
    <!--    <xsl:value-of select="test:checkJFIF($url)"/>-->
    <!--    <xsl:value-of select="test:checkEXIF($url)"/>-->
    <!--    <xsl:value-of select="test:getEXIFver($url)"/>
    <xsl:value-of select="test:getMetaInfo($url)"/>
    <xsl:value-of select="test:getHeight($url')"/>
    <xsl:value-of select="test:getWidth($url)"/>
    <xsl:value-of select="test:getColorSpace($url)"/>
    <xsl:value-of select="test:getComponentsConfiguration($url)"/>-->
    <xsl:copy-of select="test:findAll($url)"/>
<!--    <xsl:value-of select="test:getImageFormat($url)"/>
    <xsl:value-of select="test:getImageFormat($url)"/>-->
  </xsl:template>
</xsl:stylesheet>
