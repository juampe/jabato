<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="common.xsl"/>

<xsl:template match="/doc">
	<html><head>
	<xsl:call-template name="style"/>
	<title>Graficas para <xsl:value-of select="group"/></title>
	</head><body><center>
	<h1>Graficas para <xsl:value-of select="group"/></h1>
	<xsl:call-template name="graphs"/>
	</center></body></html>
</xsl:template>

<xsl:template name="graphs">
	<xsl:for-each select="graph">
		<b><xsl:value-of select="target"/></b><br/>
		<a href="/jabato/grapher?type=t&amp;target={target}"><img border="0" src="{img}" alt="{target}"/></a><br/>
	</xsl:for-each>
	<br/>
</xsl:template>

</xsl:stylesheet>
