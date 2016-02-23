<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">

	<xsl:output method="xml" indent="yes" encoding="iso-8859-1"/>

	<xsl:template match="/">
		
					
								          <xsl:if test="count(CxXMLResults/Query[@Severity='High']/Result) > 10">
[ERROR] <xsl:value-of select="count(CxXMLResults/Query[@Severity='High']/Result)"/>  High vulnerabilities detected in this project
                          </xsl:if>
                          <xsl:if test="count(CxXMLResults/Query[@Severity='Medium']/Result) > 10">
[WARNING] <xsl:value-of select="count(CxXMLResults/Query[@Severity='High']/Result)"/> Medium vulnerabilities detected in this project
                          </xsl:if>
							

	</xsl:template>
	
</xsl:stylesheet>
