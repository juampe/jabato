<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="common.xsl"/>

<xsl:template match="/doc">
	<html><head>
	<xsl:call-template name="style"/>
	<xsl:call-template name="refreshs"/>
	<title>Administrador de Jabato</title>
	</head><body><center>
	<h1>Administrador de Jabato</h1>
	<xsl:call-template name="qstrings"/>
	<xsl:call-template name="icons"/>
	<xsl:call-template name="gphlists"/>
	<xsl:call-template name="tgtlists"/>
	<xsl:call-template name="cmdlists"/>
	</center></body></html>
</xsl:template>

<xsl:template name="refreshs">
	<xsl:for-each select="refresh">
		<meta http-equiv="refresh" content="{time};url={url}"/>
	</xsl:for-each>
/</xsl:template>

<xsl:template name="qstrings">
	<xsl:for-each select="qstring">
		<a href="{qstring}">
		<img src="img/back.png" border="0" alt="Atras" title="Atras"/>
		</a><br/>
	</xsl:for-each>
</xsl:template>

<xsl:template name="icons">
	<xsl:for-each select="icon">
	<a href="admin?type={id}">
	<img src="img/{id}.png" border="0" alt="{name}" title="{name}"/>
	</a><br/><xsl:value-of select="name"/><br/>
	</xsl:for-each>
</xsl:template>

<xsl:template name="gphlists">
	<xsl:for-each select="gphlist">
		<table border="0" align="center" bgcolor="#CCCCCC" cellspacing="1">
		<tr>
		<td align="center"><font face="verdana" size="1">Elemento</font></td>
		<td align="center"><font face="verdana" size="1">Tipo</font></td>
		<td align="center"><font face="verdana" size="1">Accion</font></td>
		</tr>
		<xsl:call-template name="gphitems"/>
		</table>
		<a href="">
		<img src="img/new.png" border="0" alt="Anadir" title="Anadir"/>
		</a>
		<form action="admin" enctype="multipart/form-data" method="post">
		<input type="hidden" name="type" value="gph" class="peq"/>
		<input type="hidden" name="cmd" value="add" class="peq"/>
		<input type="hidden" name="parent" value="{parent}" class="peq"/>
		<input type="radio" name="itemtype" value="target" checked="checked" class="peq"/>Grafica
		<input type="radio" name="itemtype" value="group" class="peq"/>Grupo
		<input type="text" size="10" name="name" class="peq"/>
		<input type="submit" value="Nuevo elemento" class="peq"/>
		</form>
	</xsl:for-each>
</xsl:template>

<xsl:template name="gphitems">
	<xsl:for-each select="gphitem">
		<tr bgcolor="#FFFFFF">
                <xsl:variable name="type" select="type"/>
	        <xsl:if test="$type='target'">
			<td align="center">
			<font face="verdana" size="2">
			<a href="admin?type=tgt&amp;tname={nodename}&amp;parent={idnode}">
	                <xsl:value-of select="nodename"/></a>
	                </font></td>
			<td align="center">
			<img src="img/target.png" border="0" alt="Grafica" title="Grafica"/>
			</td>
			<td align="center">
			<a href="admin?type=tgt&amp;tname={nodename}&amp;parent={idnode}">
			<img src="img/edit.png" border="0" alt="Editar" title="Editar"/></a>
			<a href="admin?type=gph&amp;cmd=rmv&amp;parent={parent}&amp;idnode={idnode}">
	                <img src="img/del.png" border="0" alt="Borrar" title="Borrar"/>
        	        </a></td>
		</xsl:if>
		<xsl:if test="$type='group'">
			<td align="center">
	                <font face="verdana" size="2">
			<a href="admin?type=gph&amp;parent={idnode}">
	                <xsl:value-of select="nodename"/></a>
	                </font></td>
			<td align="center">
			<img src="img/group.png" border="0" alt="Grupo" title="Grupo"/>		
			</td>
			<td align="center">
			<a href="admin?type=gph&amp;parent={idnode}">
			<img src="img/edit.png" border="0" alt="Editar" title="Editar"/></a>
			<a href="admin?type=gph&amp;cmd=rmv&amp;parent={parent}&amp;idnode={idnode}">
	                <img src="img/del.png" border="0" alt="Borrar" title="Borrar"/>
                	</a></td>
		</xsl:if>
		</tr>
	</xsl:for-each>
</xsl:template>

<xsl:template name="tgtlists">
	<xsl:for-each select="tgtlist">
		<xsl:call-template name="graphics"/>
		<br/><br/>
		<table border="0" align="center" bgcolor="#CCCCCC" cellspacing="1">
		<tr>
		<td align="center"><font face="verdana" size="1">Elemento</font></td>
		<td align="center"><font face="verdana" size="1">Tipo</font></td>
		<td align="center"><font face="verdana" size="1">Accion</font></td>
		</tr>
		<xsl:call-template name="tgtitems"/>
		</table>
		<br/>
		<script languaje="javascript1.3">
		function filterTask(){
			var url;
			url="admin?type=tgt&amp;parent=<xsl:value-of select="parent"/>&amp;filter="+document.filter.filter.value;
			window.location=url;
			return 0;
		}
		</script>
		<a href="">
		<img src="img/new.png" border="0" alt="Anadir" title="Anadir"/>
		</a>
		<form name="filter" enctype="multipart/form-data" method="post">
		Filtro
		<input type="text" size="10" name="filter" value="{filter}" class="peq"/>
		<input type="button" value="Filtrar" class="peq" onclick="javascript:filterTask()"/><br/>
		</form>

		<form name="newds" action="admin" enctype="multipart/form-data" method="post">
		<input type="hidden" name="type" value="tgt" class="peq"/>
		<input type="hidden" name="cmd" value="add" class="peq"/>
		<input type="hidden" name="parent" value="{parent}" class="peq"/>
		<input type="hidden" name="tname" value="{tname}" class="peq"/>
		<xsl:call-template name="dslists"/>
		<input type="submit" value="Nuevo elemento" class="peq"/>
		</form>
	</xsl:for-each>
</xsl:template>

<xsl:template name="tgtitems">
	<xsl:for-each select="tgtitem">
		<tr bgcolor="#FFFFFF">
                <xsl:variable name="type" select="type"/>
		<td align="center">
		<font face="verdana" size="2">
                <xsl:value-of select="dsname"/>
                </font></td>
		<td align="center">
		<img src="img/ds.png" border="0" alt="Fuente" title="Fuente"/>
		</td>
		<td align="center">
		<a href="admin?type=tgt&amp;cmd=rmv&amp;parent={parent}&amp;idds={idds}">
                <img src="img/del.png" border="0" alt="Borrar" title="Borrar"/>
	        </a></td>
		</tr>
	</xsl:for-each>
</xsl:template>

<xsl:template name="graphics">
        <xsl:for-each select="graphic">
		<img src="graphic?target={tname}&amp;time=H&amp;{dss}" border="0" alt="{tname}" title="{tname}"/>
        </xsl:for-each>
</xsl:template>

<xsl:template name="dslists">
        <xsl:for-each select="dslist">
		<select name="idds">
		<xsl:call-template name="dsitems"/>
		</select>
        </xsl:for-each>
</xsl:template>

<xsl:template name="dsitems">
        <xsl:for-each select="dsitem">
		<option value="{idds}"><xsl:value-of select="dsname"/></option>
	</xsl:for-each>
</xsl:template>

<xsl:template name="cmdlists">
        <xsl:for-each select="cmdlist">
		<table border="0" align="center" bgcolor="#CCCCCC" cellspacing="1">
		<tr>
		<td align="center"><font face="verdana" size="1">Comando</font></td>
		<td align="center"><font face="verdana" size="1">Tipo</font></td>
		<td align="center"><font face="verdana" size="1">Accion</font></td>
		</tr>
		<xsl:call-template name="cmditems"/>
		</table>
		<a href="">
		<img src="img/new.png" border="0" alt="Anadir" title="Anadir"/>
		</a>
		<form action="admin" enctype="multipart/form-data" method="post">
		<input type="hidden" name="type" value="gph" class="peq"/>
		<input type="hidden" name="cmd" value="add" class="peq"/>
		<input type="hidden" name="parent" value="{parent}" class="peq"/>
		<input type="radio" name="itemtype" value="target" checked="checked" class="peq"/>Grafica
		<input type="radio" name="itemtype" value="group" class="peq"/>Grupo
		<input type="text" size="10" name="name" class="peq"/>
		<input type="submit" value="Nuevo elemento" class="peq"/>
		</form>
        </xsl:for-each>
</xsl:template>

<xsl:template name="cmditems">
        <xsl:for-each select="cmditem">
		<option value="{idcmd}"><xsl:value-of select="cmdname"/></option>
		<td align="center">
		<font face="verdana" size="2">
		<a href="admin?type=tgt&amp;tname={nodename}&amp;parent={idnode}">
                </font></td>
		<td align="center">
		<img src="img/target.png" border="0" alt="Grafica" title="Grafica"/>
		</td>
		<td align="center">
		<a href="admin?type=tgt&amp;tname={nodename}&amp;parent={idnode}">
		<img src="img/edit.png" border="0" alt="Editar" title="Editar"/></a>
		<a href="admin?type=gph&amp;cmd=rmv&amp;parent={parent}&amp;idnode={idnode}">
                <img src="img/del.png" border="0" alt="Borrar" title="Borrar"/>
	        </a></td>
	</xsl:if>

	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>
