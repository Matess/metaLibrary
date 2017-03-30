<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:test="http://test.com" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0" exclude-result-prefixes="#all">
  <xsl:include href="libexample.xsl"/>
  <xsl:template match="/">
    <xsl:variable name="url" select="xs:string('F:\exif.jpg')"/>
    <!--    <xsl:value-of select="test:getSize($url)"/>-->
    <!--    <xsl:value-of select="test:checkJFIF($url)"/>-->
    <!--    <xsl:value-of select="test:checkEXIF($url)"/>-->
    <!--    <xsl:value-of select="test:findSMTHING($url,0)"/>-->
    <!--    <xsl:value-of select="test:getEXIFver($url)"/>
    <xsl:value-of select="test:getMetaInfo($url)"/>
    <xsl:value-of select="test:getHeight($url')"/>
    <xsl:value-of select="test:getWidth($url)"/>
    <xsl:value-of select="test:getColorSpace($url)"/>
    <xsl:value-of select="test:getComponentsConfiguration($url)"/>-->
<!--    <xsl:value-of select="test:findAll($url)"/>-->
<!--    <xsl:value-of select="test:isPNG('F:\Users\Matess\Google Drive\BC_stuff\obr.png')"/>-->
    <xsl:value-of select="test:getImageFormat($url)"/>
    <xsl:value-of select="test:getImageFormat($url)"/>
<!--    <xsl:value-of select="test:printZeroIFD($url,0)"/>-->
  </xsl:template>
</xsl:stylesheet>
