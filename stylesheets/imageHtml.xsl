<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <html>
            <head>
                <title>Image</title>
            </head>
            <body>
                <img width="250" height="150" src="{//ImageURL}"/>
                <table border="3">
                    <tr bgcolor="#00FFFF">
                        <th style="text-align:left">Metadata</th>
                        <th style="text-align:left">Value</th>
                    </tr>
                    <tr>
                        <td><xsl:value-of select="name(//Make)"/></td>
                        <td><xsl:value-of select="//Make"/></td>
                    </tr>
                    <tr>
                        <td><xsl:value-of select="name(//Model)"/></td>
                        <td><xsl:value-of select="//Model"/></td>
                    </tr>
                    <tr>
                        <td><xsl:value-of select="name(//Software)"/></td>
                        <td><xsl:value-of select="//Software"/></td>
                    </tr>
                </table>
            </body>
        </html>
        
    </xsl:template>
</xsl:stylesheet>