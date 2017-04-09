<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:image="https://github.com/Matess/xsltLib" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0" exclude-result-prefixes="#all">
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="metaLibrary.xsl"/>
  <xsl:template match="/">
    <xsl:variable name="url" select="xs:string('F:\exif.jpg')"/>
    <xsl:variable name="url2" select="xs:string('F:\exif2.jpg')"/>
    <xsl:variable name="url3" select="xs:string('F:\png.png')"/>
    <xsl:variable name="url4" select="xs:string('F:\gif.gif')"/>

    <ImagesInfo>
      <Image format="{image:getImageFormat($url)}">
        <ImageURL><xsl:value-of select="$url"/></ImageURL>
        <xsl:copy-of select="image:findAll($url)"/>
      </Image>
      <Image format="{image:getImageFormat($url2)}">
        <ImageURL><xsl:value-of select="$url2"/></ImageURL>
        <xsl:copy-of select="image:findAll($url2)"/>
      </Image>
      <Image format="{image:getImageFormat($url3)}">
        <ImageURL><xsl:value-of select="$url3"/></ImageURL>
        <xsl:copy-of select="image:findAll($url3)"/>
      </Image>
      <Image format="{image:getImageFormat($url4)}">
        <ImageURL><xsl:value-of select="$url4"/></ImageURL>
        <xsl:copy-of select="image:findAll($url4)"/>
      </Image>
    </ImagesInfo>
  </xsl:template>
</xsl:stylesheet>
