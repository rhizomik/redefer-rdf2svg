package net.rhizomik.redefer.rdf2svg;

import net.rhizomik.jena.builtin.StrContains;
import net.rhizomik.jena.builtin.StrNotContains;
import org.apache.commons.io.IOUtils;
import org.apache.jena.rdf.model.*;
import org.apache.jena.reasoner.Reasoner;
import org.apache.jena.reasoner.rulesys.BuiltinRegistry;
import org.apache.jena.reasoner.rulesys.GenericRuleReasoner;
import org.apache.jena.reasoner.rulesys.Rule;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.logging.Logger;

@Service
public class RDF2DotService {
	private static final Logger log = Logger.getLogger(RDF2DotService.class.getName());

	@Value("${net.rhizomik.redefer.rdf2svg.defaultLineLength}")
	static String defaultLineLength = "50";
	@Value("${net.rhizomik.redefer.rdf2svg.defaultMaxLineLength}")
	static String defaultMaxLineLength = "80";
	@Value("${net.rhizomik.redefer.rdf2svg.rules}")
	static String DEFAULT_RULES = "rules/showgraph.jrule";
	static String language = "en";

	private String rulesUrl;

	RDF2DotService(String rulesUrl) {
		this.rulesUrl = rulesUrl;
		BuiltinRegistry.theRegistry.register(new StrContains());
		BuiltinRegistry.theRegistry.register(new StrNotContains());
	}

	RDF2DotService() throws IOException {
		ClassPathResource r = new ClassPathResource(DEFAULT_RULES);
		this.rulesUrl = r.getURL().toString();
		BuiltinRegistry.theRegistry.register(new StrContains());
		BuiltinRegistry.theRegistry.register(new StrNotContains());
	}

	public String RDFtoDot(String rdf, String format) throws IOException, TransformerException {
		Model model = ModelFactory.createDefaultModel();
		try {
			model.read(new URL(rdf).toString(), format);
		} catch (MalformedURLException e) {
			model.read(IOUtils.toInputStream(rdf, StandardCharsets.UTF_8), null, format);
		}
		Model graph = runInference(model, new URL(rulesUrl),
				Integer.parseInt(defaultLineLength), Integer.parseInt(defaultMaxLineLength));
		return rdfModel2dot(graph);
	}

    private Model runInference(Model data, URL rules, int lineLength, int maxLineLength) throws IOException
	{
		Reasoner reasoner = new GenericRuleReasoner(Rule.rulesFromURL(rules.toString()));
		InfModel inf = ModelFactory.createInfModel(reasoner, data);
		
		// Break long literals (more than lineLength chars) using carriage returns
		Model remove = ModelFactory.createDefaultModel();
		Model add = ModelFactory.createDefaultModel();
		Selector sel = new SimpleSelector(null, null, (String)null);
		for(StmtIterator sIt = inf.listStatements(sel); sIt.hasNext();)
		{
			Statement s = sIt.nextStatement();
			if(!s.getObject().isLiteral() || s.getPredicate().hasURI("http://rhizomik.net/ontologies/2008/05/gv.rdfs#URL"))
				continue;
			String l = s.getString();
			
			String lp = paginate(l, lineLength, maxLineLength);
			if (lp.length() != l.length())
			{
				remove.add(s);
				add.add(s.getSubject(), s.getPredicate(), lp, s.getLanguage());
			}
		}
		inf.remove(remove);
		inf.add(add);
		
		return inf;
	}
	
	private String paginate(String l, int lineLength, int maxLineLength) 
	{
		String lf = "<BR/>";
		if (l.length() > lineLength)
		{
			int pos = l.lastIndexOf(' ', lineLength);
			if (pos > 0)
				l = l.substring(0, pos) + lf + paginate(l.substring(pos+1, l.length()), lineLength, maxLineLength);
			else if (l.length() > maxLineLength)
				l = l.substring(0, maxLineLength) + lf + paginate(l.substring(maxLineLength, l.length()), lineLength, maxLineLength);
			else
				l = l.substring(0, lineLength) + paginate(l.substring(lineLength, l.length()), lineLength, maxLineLength);
		}	
		return l;
	}

	private String rdfModel2dot(Model graph)
		throws TransformerException, IOException 
	{
		Source transformation = new StreamSource(getClass().getClassLoader().getResourceAsStream("xsl/rdf2dot.xsl"));

		StringWriter result = new StringWriter();

		TransformerFactory factory = TransformerFactory.newInstance();
		Transformer transformer = factory.newTransformer(transformation);
		
		ByteArrayOutputStream o = new ByteArrayOutputStream();
		graph.write(o, "RDF/XML");
		o.flush();

		ByteArrayInputStream rdf = new ByteArrayInputStream(o.toByteArray());
		
		transformer.setParameter("language", language);
		StreamSource inStream = new StreamSource(rdf);
		StreamResult outStream = new StreamResult(result);
		transformer.transform(inStream, outStream);

		return result.toString();
	}
}
