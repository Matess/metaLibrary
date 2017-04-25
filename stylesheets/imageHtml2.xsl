<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <html>
            <head>
                <title>Images</title>
            </head>
            <body>
                <xsl:for-each select="/Images/Image[@format!='Unrecognized image file format']">
                    <img style="float:left" width="{150}" height="{150}" src="{./@url}"/>
                    <table style="height:150" border="3">
                    <tr bgcolor="#00FF00">
                        <th style="text-align:left">Metadata</th>
                        <th style="text-align:left">Value</th>
                    </tr>
                    <tr>
                        <td><xsl:value-of select="name(Width)"/></td>
                        <td><xsl:value-of select="Width"/></td>
                    </tr>
                    <tr>
                        <td><xsl:value-of select="name(Height)"/></td>
                        <td><xsl:value-of select="Height"/></td>
                    </tr>
                </table>
                </xsl:for-each>
            </body>
        </html>
        
    </xsl:template>
</xsl:stylesheet>