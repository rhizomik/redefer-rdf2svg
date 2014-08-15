<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>RDF2SVG - RDF to SVG Renderer</title>
    <link href="style/rhizomik.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="logo"><a href="http://rhizomik.net"><img src="images/rhizomik-eye-100px.png"/></a></div>
<h1>RDF2SVG - RDF to SVG Renderer</h1>
<form method="post" action="render" name="render" target="_blank" accept-charset="UTF-8">
    <p>Input RDF or URI pointing to RDF content:</p>
    <p><textarea cols="80" rows="10" name="rdf" id="rdf">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
 &lt;rdf:RDF xmlns:swrc="http://swrc.ontoware.org/ontology#"
  	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  	xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#" &gt;
   &lt;swrc:AssociateProfessor rdf:about="http://rhizomik.net/~roberto"&gt;
     &lt;swrc:homepage&gt;http://rhizomik.net/html/roberto&lt;/swrc:homepage&gt;
     &lt;vcard:EMAIL&gt;
       &lt;vcard:internet&gt;
         &lt;rdf:value&gt;roberto@rhizomik.net&lt;/rdf:value&gt;
       &lt;/vcard:internet&gt;
     &lt;/vcard:EMAIL&gt;
     &lt;swrc:affiliation rdf:resource="http://www.udl.cat"/&gt;
     &lt;vcard:ADR&gt;
       &lt;vcard:work&gt;
         &lt;vcard:Street&gt;Jaume II, 69&lt;/vcard:Street&gt;
         &lt;vcard:Locality&gt;Lleida&lt;/vcard:Locality&gt;
         &lt;vcard:Country&gt;ES&lt;/vcard:Country&gt;
         &lt;vcard:Pcode&gt;E-25001&lt;/vcard:Pcode&gt;
       &lt;/vcard:work&gt;
     &lt;/vcard:ADR&gt;
     &lt;rdfs:label&gt;Roberto García González&lt;/rdfs:label&gt;
     &lt;vcard:N rdf:parseType="Resource"&gt;
       &lt;vcard:Family&gt;García González&lt;/vcard:Family&gt;
       &lt;vcard:Given&gt;Roberto&lt;/vcard:Given&gt;
     &lt;/vcard:N&gt;
     &lt;vcard:TEL&gt;
       &lt;vcard:voice&gt;
         &lt;rdf:type rdf:resource="http://www.w3.org/2001/vcard-rdf/3.0#work"/&gt;
         &lt;rdf:value&gt;+34-973-702-742&lt;/rdf:value&gt;
       &lt;/vcard:voice&gt;
     &lt;/vcard:TEL&gt;
     &lt;vcard:FN&gt;Roberto García González&lt;/vcard:FN&gt;
   &lt;/swrc:AssociateProfessor&gt;
   &lt;rdf:Description rdf:about="http://swrc.ontoware.org/ontology#AssociateProfessor"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Associate Professor&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.diei.udl.es"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Computer Science and Engineering Department&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Family"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Family Name&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Street"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Street&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Pcode"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Postal Code&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#FN"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Full Name&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#N"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Name&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Given"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Given Name&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Country"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Country&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#ADR"&gt;
     &lt;rdfs:label xml:lang="en"&gt;Address&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://swrc.ontoware.org/ontology#AssociateProfessor"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Profesor Contratado Doctor&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.diei.udl.es"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Departamento de Informática e Ingeniería Industrial&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Family"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Apellido&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Street"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Calle&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Pcode"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Código Postal&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#FN"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Nombre Completo&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#N"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Nombre&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Given"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Nombre&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#Country"&gt;
     &lt;rdfs:label xml:lang="es"&gt;País&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
   &lt;rdf:Description rdf:about="http://www.w3.org/2001/vcard-rdf/3.0#ADR"&gt;
     &lt;rdfs:label xml:lang="es"&gt;Dirección&lt;/rdfs:label&gt;
   &lt;/rdf:Description&gt;
 &lt;/rdf:RDF&gt;  </textarea></p>
    <p>What to do:</p>
    <p><select name="rules">
    	<option selected="selected" value="<%=request.getRequestURL()%>rules/showgraph.jrule">Show graph</option>
    	<option value="<%=request.getRequestURL()%>rules/showclasshierarchy.jrule">Show class hierarchy</option>
    	<option value="<%=request.getRequestURL()%>rules/showontology.jrule">Show ontology</option>
    </select></p>
    <p>Input format:</p>
    <p><select name="format" id="format">
		<option selected="selected" value="RDF/XML">RDF/XML</option>
		<option value="N-TRIPLE">N-Triples</option>
		<option value="N3">N3</option>
	</select></p>
    <p>Language (en, es, de, fr,...):</p>
    <p><input type="text" name="language" id="language" value="es"> (Filters preferred language if defined in input RDF using xml:lang, shows all if none defined)</p>
    <input type="submit" name="Submit" value="Submit">
</form>
<h1>RDF to SVG API</h1>

<p>The base address of the service is: <b><%=request.getRequestURL()%>render</b></p>
<p>It can called using <b>GET</b> or <b>POST</b>. The former is recommended when the RDF to be transformed is available from a URI, the latter when direct input is provided.</p>
<p>The parameters of the service are:</p>
<ul>
<li><b>rdf=URI|RDF/XML</b>: the RDF/XML to be processed or a URI (content negotiated) where it can be retrieved from.</li>
<li><b>format=RDF/XML|N-TRIPLE|N3</b>: the language the input RDF is serialised in.</li>
<li><b>mode=svg|snippet</b>: defines if the output is a full SVG file or just a snippet for inclusion in other web pages (default "svg").</li>
<li><b>rules=URI</b>: it specifies the set of Jena rules to be used in order to determine what is going to be rendered. Available examples:
<ul>
<li><b><%=request.getRequestURL()%>rules/showgraph.jrule</b>: draws the whole graph in a condensed way (boxes for resources and their types, CURIEs,...)</li>
<li><b><%=request.getRequestURL()%>rules/showclasshierarchy.jrule</b>: draws just the classes hierarchy.</li>
</ul>
</li>
</ul>
<p>Examples using GET:</p>
<ul>
<li><p>Show a RDF graph: <br><a href="<%=request.getRequestURL()%>render?rdf=http://rhizomik.net/html/ontologies/mpeg7ontos/examples/descriptionExample002.rdf&format=RDF/XML&mode=svg&rules=<%=request.getRequestURL()%>rules/showgraph.jrule" target="_blank"><b><%=request.getRequestURL()%>render</b>?<b>rdf</b>=http://bnb.data.bl.uk/id/resource/010758360&amp;<b>format</b>=RDF/XML&amp;<b>mode</b>=svg&amp;<b>rules</b>=<%=request.getRequestURL()%>rules/showgraph.jrule</a></p></li>
<li><p>Show the class hierarcy in an ontology: <br><a href="<%=request.getRequestURL()%>render?rdf=https://raw.github.com/structureddynamics/Bibliographic-Ontology-BIBO/1.3/bibo.xml.owl&format=RDF/XML&mode=svg&rules=<%=request.getRequestURL()%>rules/showclasshierarchy.jrule" target="_blank"><b><%=request.getRequestURL()%>render</b>?<b>rdf</b>=http://purl.org/ontology/bibo/&amp;<b>format</b>=RDF/XML&amp;<b>mode</b>=svg&amp;<b>rules</b>=<%=request.getRequestURL()%>rules/showclasshierarchy.jrule</a></p></li>
<li><p>Show ontology: <br><a href="<%=request.getRequestURL()%>render?rdf=http://rhizomik.net/ontologies/copyrightonto.owl&format=RDF/XML&mode=svg&rules=<%=request.getRequestURL()%>rules/showontology.jrule" target="_blank"><b><%=request.getRequestURL()%>render</b>?<b>rdf</b>=http://rhizomik.net/ontologies/copyrightonto.owl&amp;<b>format</b>=RDF/XML&amp;<b>mode</b>=svg&amp;<b>rules</b>=<%=request.getRequestURL()%>rules/showontology.jrule</a></p></li>
</ul></body></html>