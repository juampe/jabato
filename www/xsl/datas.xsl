<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="common.xsl"/>

<xsl:template match="/doc">
	<html><head>
	<title>Graficas</title>
	</head><body><center>
	<h1>Graficas</h1>
	<xsl:call-template name="graphs"/>
	</center></body></html>
</xsl:template>

<xsl:template name="graphs">
	<xsl:for-each select="graph">
		<xsl:value-of select="name"/> = <xsl:value-of select="value"/>
		<img border="0" src="{img}"/><br/><br/>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
