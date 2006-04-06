<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="common.xsl"/>

<xsl:template match="/doc">
	<html><head>
	<xsl:call-template name="style"/>
	<title>Jabato</title>
	</head><body><center>
	<h1>Jabato</h1>
	<xsl:call-template name="groups"/>
	<xsl:call-template name="graphs"/>
	</center></body></html>
</xsl:template>

<xsl:template name="groups">
        <xsl:for-each select="group">
                <table border="0" align="center" vlalign="top"><tr><td>
                <a href="/jabato/grapher?parent={idnode}">
                <img border="0" src="/jabato/img/grp.png"/></a><br/>
                <xsl:value-of select="name"/>
                </td></tr></table>
        </xsl:for-each>
</xsl:template>


<xsl:template name="graphs">
        <xsl:for-each select="graph">
                <xsl:variable name="type" select="type"/>
                <xsl:if test="$type='H'">
                        <xsl:call-template name="dss"/>
                </xsl:if>
		<b><xsl:value-of select="target"/></b><br/>
                <b><xsl:value-of select="time"/></b><br/>
		<a href="/jabato/grapher?parent={idnode}&amp;target={target}"><img border="0" src="{img}" alt="{target}"/></a><br/>
        </xsl:for-each>
</xsl:template>

<xsl:template name="dss">
        <xsl:for-each select="ds">
                <xsl:value-of select="name"/> = <xsl:value-of select="value"/>
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
