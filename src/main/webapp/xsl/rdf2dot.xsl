<?xml version="1.0"?>
<xsl:transform version="2.0" xmlns:xo="http://rhizomik.net/redefer" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:gv="http://rhizomik.net/ontologies/2008/05/gv.rdfs#">
	
	<xsl:param name="Debug" select="0"/>
	
	<xsl:output method="text" media-type="text/plain" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="GVns" select='"http://rhizomik.net/ontologies/2008/05/gv.rdfs#"'/>
	<xsl:param name="language"></xsl:param>
	<xsl:param name="namespaces">true</xsl:param>
	
	<xsl:template match="/rdf:RDF">
		<xsl:for-each select="*[@rdf:about='http://rhizomik.net/ontologies/2008/05/gv.rdfs#graph']">
			<xsl:variable name="it" select="."/>
			<xsl:text>digraph </xsl:text>
			<xsl:call-template name="eachGraph">
				<xsl:with-param name="it" select="$it"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="eachGraph">
		<xsl:param name="it"/>
		<xsl:param name="cluster"/>
		<xsl:value-of select="concat($cluster, generate-id($it))"/>
		<xsl:text> { </xsl:text>
		<xsl:text> label="Powered by http://rhizomik.net"; </xsl:text>
		<!-- graph attributes see Graphviz spec table 1 -->
		<xsl:for-each select='$it/*[namespace-uri() = $GVns and (
			      local-name() = "center"
		           or local-name() = "clusterrank"
		           or local-name() = "color"
		           or local-name() = "concentrate"
		           or local-name() = "fontcolor"
		           or local-name() = "fontname"
		           or local-name() = "fontsize"
      		       or local-name() = "label"
		           or local-name() = "layerseq"
		           or local-name() = "margin"
		           or local-name() = "mclimit"
		           or local-name() = "nodesep"
		           or local-name() = "nslimit"
		           or local-name() = "ordering"
		           or local-name() = "orientation"
		           or local-name() = "page"
		           or local-name() = "rank"
		           or local-name() = "rankdir"
		           or local-name() = "ranksep"
		           or local-name() = "ratio"
		           or local-name() = "size"
		           or local-name() = "overlap"
		           or local-name() = "splines"
		           or local-name() = "labelloc"
			   )]'>
			<!--@@ ...others-->
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<!-- @@quoting? -->
			<xsl:text>";</xsl:text>
		</xsl:for-each>
		<!-- explicit nodes -->
		<xsl:for-each select="$it/gv:hasNode/@rdf:resource | $it/gv:hasNode/@rdf:nodeID">
			<xsl:variable name="nodeURI" select="current()"/>
			<xsl:variable name="nodeElt" select="/rdf:RDF/*[@rdf:about=$nodeURI] | /rdf:RDF/*[@rdf:nodeID=$nodeURI]"/>
			<xsl:if test="$nodeElt">
				<xsl:call-template name="eachNode">
					<xsl:with-param name="graphElt" select="$it"/>
					<xsl:with-param name="nodeElt" select="$nodeElt"/>
					<xsl:with-param name="nodeURI" select="$nodeURI"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="$it/gv:hasNode[not(@rdf:resource) and not(@rdf:nodeID)]">
			<xsl:variable name="isPreferredLanguage">
					<xsl:call-template name="isPreferredLanguage"/>
			</xsl:variable>
			<xsl:if test="$isPreferredLanguage='true'">
				<xsl:call-template name="eachLiteral">
					<xsl:with-param name="nodeValue" select="normalize-space(.)"/>
					<xsl:with-param name="datatype" select="@rdf:datatype"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="$it/gv:subgraph/@rdf:resource">
			<xsl:variable name="it2" select="/rdf:RDF/*[@rdf:about=current()]"/>
			<xsl:text>subgraph </xsl:text>
			<xsl:call-template name="eachGraph">
				<xsl:with-param name="it" select="$it2"/>
				<xsl:with-param name="cluster" select='"cluster"'/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template name="eachLiteral">
		<xsl:param name="nodeValue"/>
		<xsl:param name="datatype"/>
		<xsl:variable name="value">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$nodeValue"/>
				<xsl:with-param name="replace" select="'&quot;'"/>
				<xsl:with-param name="with" select="'&amp;quot;'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text>"&amp;quot;</xsl:text>
		<xsl:value-of select="$value"/>
		<xsl:text>&amp;quot;" [</xsl:text>
		<!-- node attributes -->
		<xsl:for-each select='/rdf:RDF/*[@rdf:about="urn:literals"]/*[namespace-uri() = $GVns and (
			      local-name() = "color"
				or local-name() = "shape"
				or local-name() = "style"
				or local-name() = "fontcolor"
				or local-name() = "fontname"
				or local-name() = "fontsize"
				or local-name() = "height"
				or local-name() = "width"
				or local-name() = "layer"
				or local-name() = "URL"
				or local-name() = "sides"
				or local-name() = "shapefile")
				]'>
			<!-- "URL" not in the original file format docs, but seems to be supported; cf http://www.graphviz.org/webdot/tut2.html-->
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="normalize-space(.)"/>
			<xsl:text>",</xsl:text>	
		</xsl:for-each>
		
		<xsl:text>label="&amp;quot;</xsl:text>
		<xsl:value-of select="$value"/>
		<xsl:text>&amp;quot;</xsl:text>
		<xsl:if test="$datatype">
			<xsl:text>^^</xsl:text>
			<xsl:value-of select="$datatype"/>
		</xsl:if>
		<xsl:text>"];</xsl:text>
	</xsl:template>

	<xsl:template name="eachNode">
		<xsl:param name="graphElt"/>
		<xsl:param name="nodeElt"/>
		<xsl:param name="nodeURI"/>
		<xsl:text>"</xsl:text>
		<xsl:value-of select="$nodeURI"/>
		<xsl:text>" [</xsl:text>
		<!-- node attributes -->
		<xsl:for-each select='$nodeElt/*[namespace-uri() = $GVns and (
			      local-name() = "color"
				or local-name() = "shape"
				or local-name() = "style"
				or local-name() = "fontcolor"
				or local-name() = "fontname"
				or local-name() = "fontsize"
				or local-name() = "height"
				or local-name() = "width"
				or local-name() = "layer"
				or local-name() = "URL"
				or local-name() = "sides"
				or local-name() = "shapefile")
				]'>
			<!-- "URL" not in the original file format docs, but seems to be supported; cf http://www.graphviz.org/webdot/tut2.html-->
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="normalize-space(.)"/>
			<xsl:text>",</xsl:text>	
		</xsl:for-each>
		
		<!-- Combine multiple classLabels and label. If label empty put " " in order to avoid DOT displays node id -->
		<!--xsl:if test='$nodeElt/*[namespace-uri() = $GVns and (local-name() = "classLabel" or local-name() = "label")]'-->
			<xsl:text>label="</xsl:text>
			<xsl:for-each select="$nodeElt/*[namespace-uri() = $GVns and  local-name() = 'classLabel']">
				<xsl:call-template name="getLabel">
					<xsl:with-param name="uri" select="."/>
					<xsl:with-param name="property" select="''"/>
				</xsl:call-template>
				<xsl:if test="position() = last()-1"><xsl:text>, </xsl:text></xsl:if>
			</xsl:for-each>
			<xsl:if test='$nodeElt/*[namespace-uri() = $GVns and local-name() = "classLabel"]'>
				<xsl:text>:\n</xsl:text>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$nodeElt/@rdf:about">
					<xsl:call-template name="getLabel">
						<xsl:with-param name="uri" select="$nodeElt/@rdf:about"/>
						<xsl:with-param name="property" select="$nodeElt"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$nodeElt/@rdf:nodeID">
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:text>",</xsl:text>
		<!--/xsl:if-->		
		<xsl:text>];</xsl:text>
		
		<!-- edges -->
		<xsl:for-each select="$nodeElt/*">
			<!-- iterate over all properties of the default or preferred language-->
			<xsl:variable name="isPreferredLanguage">
				<xsl:call-template name="isPreferredLanguage"/>
			</xsl:variable>
			<xsl:if test="$isPreferredLanguage='true'">
				<xsl:variable name="obj">
					<xsl:choose>
						<xsl:when test="@rdf:resource">
							<xsl:value-of select="./@rdf:resource"/>
						</xsl:when>
						<xsl:when test="@rdf:nodeID">
							<xsl:value-of select="./@rdf:nodeID"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>&amp;quot;</xsl:text>
							<xsl:call-template name="replace-string">
								<xsl:with-param name="text" select="normalize-space(.)"/>
								<xsl:with-param name="replace" select="'&quot;'"/>
								<xsl:with-param name="with" select="'&amp;quot;'"/>
							</xsl:call-template>
							<xsl:text>&amp;quot;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="pred" select="concat(namespace-uri(),  local-name())"/>
				<xsl:if test="$Debug>4">
					<xsl:message>propertyElt in nodeElt:subj: <xsl:value-of select="$nodeURI"/>  pred: <xsl:value-of select="$pred"/></xsl:message>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$graphElt/gv:hasEdgeProperty/@rdf:resource=$pred">
						<xsl:call-template name="doEdge">
							<xsl:with-param name="nodeURI" select="$nodeURI"/>
							<xsl:with-param name="pred" select="$pred"/>
							<xsl:with-param name="obj" select="$obj"/>
							<xsl:with-param name="edgeElt" select="/rdf:RDF/*[@rdf:about=$pred]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="/rdf:RDF/gv:EdgeProperty[@rdf:about=$pred]">
						<xsl:call-template name="doEdge">
							<xsl:with-param name="nodeURI" select="$nodeURI"/>
							<xsl:with-param name="pred" select="$pred"/>
							<xsl:with-param name="obj" select="$obj"/>
							<xsl:with-param name="edgeElt" select="/rdf:RDF/*[@rdf:about=$pred]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test='/rdf:RDF/*[@rdf:about=$pred]/rdf:type[@rdf:resource=concat($GVns, "EdgeProperty")]'>
						<xsl:call-template name="doEdge">
							<xsl:with-param name="nodeURI" select="$nodeURI"/>
							<xsl:with-param name="pred" select="$pred"/>
							<xsl:with-param name="obj" select="$obj"/>
							<xsl:with-param name="edgeElt" select="/rdf:RDF/*[@rdf:about=$pred]"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="doEdge">
		<xsl:param name="nodeURI"/>
		<xsl:param name="pred"/>
		<xsl:param name="obj"/>
		<xsl:param name="edgeElt"/>
		<xsl:text>"</xsl:text>
		<xsl:value-of select="$nodeURI"/>
		<xsl:text>" -&gt; "</xsl:text>
		<xsl:value-of select="$obj"/>
		<xsl:text>"</xsl:text>
		<xsl:text> [ /* edge attributes */ </xsl:text>
		<!-- edge attributes all except id -->
		<xsl:for-each select='$edgeElt/*[local-name() = "color"
			          or local-name() = "decorate"
			          or local-name() = "dir"
			          or local-name() = "fontcolor"
			          or local-name() = "fontname"
			          or local-name() = "fontsize"
			          or local-name() = "layer"
			          or local-name() = "minlen"
			          or local-name() = "style"
			          or local-name() = "weight"
				  ]'>
			<!--@@ ...others-->
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="normalize-space(.)"/>
			<!-- @@quoting? -->
			<xsl:text>",</xsl:text>
		</xsl:for-each>
		<xsl:text>label="</xsl:text>
		<xsl:call-template name="getLabel">
			<xsl:with-param name="uri" select="$pred"/>
			<xsl:with-param name="property" select="''"/>
		</xsl:call-template>
		<xsl:text>",</xsl:text>
		<xsl:text>];
</xsl:text>
	</xsl:template>
	<!-- don't pass text thru -->
	<xsl:template match="text()|@*">
</xsl:template>

<!-- UTILITIES -->

	<xsl:template name="isPreferredLanguage">
		<xsl:variable name="element">
			<xsl:value-of select="name()"/>
		</xsl:variable>
		<xsl:choose>
			<!-- If no preferred language defined, show all, otherwise... -->
			<xsl:when test="$language=''">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- Firstly, select if is preferred language -->
			<xsl:when test="contains(@xml:lang,$language)">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- Secondly, select default language version if there is not a preferred language version -->
			<xsl:when test="contains(@xml:lang,'en') and count(parent::*/*[name()=$element and contains(@xml:lang,$language)])=0">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- Thirdly, select version without language tag if there is not preferred language nor default language version -->
			<xsl:when test="not(@xml:lang) and count(parent::*/*[name()=$element and contains(@xml:lang,$language)])=0 and 
						    count(parent::*/*[name()=$element and contains(@xml:lang,'en')])=0 ">
			<xsl:value-of select="true()"/>
			</xsl:when>
			<!-- Otherwise, ignore -->
			<xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getLabel">
		<xsl:param name="uri"/>
		<xsl:param name="property"/>
		<xsl:variable name="namespace">
			<xsl:call-template name="get-ns">
				<xsl:with-param name="uri" select="$uri"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:call-template name="get-name">
				<xsl:with-param name="uri" select="$uri"/>
			</xsl:call-template>
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="$language='' and //*[@rdf:about=$uri]/rdfs:label">
				<xsl:call-template name="buildList">
					<xsl:with-param name="elements" select="//*[@rdf:about=$uri]/rdfs:label"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="//*[@rdf:about=$uri]/rdfs:label[contains(@xml:lang,$language)]">
				<xsl:value-of select="//*[@rdf:about=$uri]/rdfs:label[contains(@xml:lang,$language)]"/>
			</xsl:when>
			<xsl:when test="//*[@rdf:about=$uri]/rdfs:label[contains(@xml:lang,'en')]">
				<xsl:value-of select="//*[@rdf:about=$uri]/rdfs:label[contains(@xml:lang,'en')]"/>
			</xsl:when>
			<xsl:when test="//*[@rdf:about=$uri]/rdfs:label[not(@xml:lang)]">
				<xsl:value-of select="//*[@rdf:about=$uri]/rdfs:label[not(@xml:lang)]"/>
			</xsl:when>
			<xsl:when test="$namespaces='true' and namespace::*[.=$namespace and name()!='']">
				<xsl:variable name="namespaceAlias">
					<xsl:value-of select="name(namespace::*[.=$namespace and name()!=''])"/>
				</xsl:variable>
				<xsl:value-of select="concat(concat($namespaceAlias,':'),$localname)"/>
			</xsl:when>
			<xsl:when test="$namespaces='false'">
				<xsl:value-of select="$localname"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$namespaces='true' and $namespace = namespace::*[name()='']">
						<xsl:value-of select="concat(':',$localname)"/>
					</xsl:when>
					<xsl:when test="$namespaces='false' and $namespace = namespace::*[name()='']">
						<xsl:value-of select="$localname"/>
					</xsl:when>
					<xsl:when test="$property = '' or $property = 'type'">
						<xsl:value-of select="$localname"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$uri"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Builds a list separated by commas with all the elements in the input set -->
	<xsl:template name="buildList">
		<xsl:param name="elements"/>
		<xsl:for-each select="$elements">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="substring-after-last">
		<xsl:param name="text"/>
		<xsl:param name="chars"/>
		<xsl:choose>
		  <xsl:when test="contains($text, $chars)">
			<xsl:variable name="last" select="substring-after($text, $chars)"/>
			<xsl:choose>
			  <xsl:when test="contains($last, $chars)">
				<xsl:call-template name="substring-after-last">
				  <xsl:with-param name="text" select="$last"/>
				  <xsl:with-param name="chars" select="$chars"/>
				</xsl:call-template>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="$last"/>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="$text"/>
		  </xsl:otherwise>
		</xsl:choose>
  	</xsl:template>
  
  	<xsl:template name="substring-before-last">
		<xsl:param name="text"/>
		<xsl:param name="chars"/>
		<xsl:choose>
		  <xsl:when test="contains($text, $chars)">
			<xsl:variable name="before" select="substring-before($text, $chars)"/>
			<xsl:variable name="after" select="substring-after($text, $chars)"/>
			<xsl:choose>
			  <xsl:when test="contains($after, $chars)">
			    <xsl:variable name="before-last">
					<xsl:call-template name="substring-before-last">
				  		<xsl:with-param name="text" select="$after"/>
				  		<xsl:with-param name="chars" select="$chars"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($before,concat($chars,$before-last))"/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="$before"/>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="$text"/>
		  </xsl:otherwise>
		</xsl:choose>
  	</xsl:template>
  	
  	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
			<xsl:when test="contains($text,$replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:value-of select="$with"/>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="substring-after($text,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="with" select="$with"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
  	</xsl:template>
  
    <xsl:template name="get-ns">
		<xsl:param name="uri"/>
		<xsl:choose>
	  		<xsl:when test="contains($uri,'#')">
				<xsl:value-of select="concat(substring-before($uri,'#'),'#')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="ns-without-slash">
					<xsl:call-template name="substring-before-last">
						<xsl:with-param name="text" select="$uri"/>
						<xsl:with-param name="chars" select="'/'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($ns-without-slash, '/')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
    <xsl:template name="get-name">
		<xsl:param name="uri"/>
		<xsl:choose>
	  		<xsl:when test="contains($uri,'#')">
				<xsl:value-of select="substring-after($uri,'#')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="text" select="$uri"/>
					<xsl:with-param name="chars" select="'/'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:transform>
