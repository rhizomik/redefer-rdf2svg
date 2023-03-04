package net.rhizomik.redefer.rdf2svg;

import com.apicatalog.jsonld.JsonLdError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.xml.transform.TransformerException;
import java.io.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

@Service
public class RDF2SVGService {
	@Value("${net.rhizomik.redefer.rdf2svg.dotPath}")
	private final String dotPath = "/usr/bin/dot";

	@Autowired RDF2DotService rdf2Dot;

	public String RDFtoSVG(String rdf, String format) throws IOException, TransformerException, JsonLdError {
		String dot = rdf2Dot.RDFtoDot(rdf, format);

		Runtime rt = Runtime.getRuntime();
		Process pr = rt.exec(dotPath+" -Gcharset=UTF-8 -Nshape=plaintext -Tsvg");

		BufferedOutputStream prIn = new BufferedOutputStream(pr.getOutputStream());
		byte[] dotBytes = dot.getBytes(Charset.defaultCharset());
		for (byte dotByte : dotBytes) prIn.write(dotByte);
		prIn.close();

		StringWriter out = new StringWriter();

		if (pr.getErrorStream().available() > 0)
		{
			BufferedReader error = new BufferedReader(new InputStreamReader(pr.getErrorStream()));
			String line;
			while((line = error.readLine()) != null)
				out.write(line);
			throw new IOException(out.toString());
		}
		else {
			BufferedReader input = new BufferedReader(new InputStreamReader(pr.getInputStream(), StandardCharsets.UTF_8));
			String line;
			while ((line = input.readLine()) != null)
				out.write(line + "\n");
			return out.toString();
		}
	}
}
