<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="common.xsl"/>

<xsl:template match="/doc">
	<html><head>
	<xsl:call-template name="style"/>
	<title>Graficas para <xsl:value-of select="target"/></title>
	</head><body><center>
	<h1>Graficas para <xsl:value-of select="target"/></h1>
	<xsl:call-template name="graphs"/>
	</center></body></html>
</xsl:template>

<xsl:template name="graphs">
	<xsl:for-each select="graph">
		<xsl:variable name="type" select="type"/>
		<xsl:if test="$type='H'">
			<xsl:call-template name="dss"/>
		</xsl:if>
		<b><xsl:value-of select="time"/></b><br/>
		<img border="0" src="{img}" alt="{time}"/><br/><br/>
	</xsl:for-each>
</xsl:template>

<xsl:template name="dss">
	<xsl:for-each select="ds">
		<xsl:value-of select="name"/> =	<xsl:value-of select="value"/>
		<xsl:variable name="msg" select="msg"/>
		<xsl:if test="$msg!=''">
			(<xsl:value-of select="dsc"/>)
			[<xsl:value-of select="msg"/>]
		</xsl:if>
		<br/>
	</xsl:for-each>
	<br/>
</xsl:template>

</xsl:stylesheet>
