<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="common.xsl"/>

<xsl:template match="/doc">
	<html><head>
	<xsl:call-template name="style"/>
	<title>Sistema de graficas Jabato</title>
	</head><body><center>
	<h1>Sitema de graficas Jabato</h1>
	<xsl:call-template name="groups"/>
	</center></body></html>
</xsl:template>

<xsl:template name="groups">
	<xsl:for-each select="group">
		<table border="0" align="center" vlalign="top"><tr><td>
		<a href="/jabato/grapher?type=g&amp;group={.}">
		<img border="0" src="/jabato/img/grp.png"/></a><br/>
		<xsl:value-of select="."/>
		</td></tr></table>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
