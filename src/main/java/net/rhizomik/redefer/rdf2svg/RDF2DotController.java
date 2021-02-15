package net.rhizomik.redefer.rdf2svg;

import org.apache.jena.util.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.xml.transform.TransformerException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * Created by http://rhizomik.net/~roberto/
 */
@Controller
public class RDF2DotController {

    @Autowired RDF2DotService rdf2Dot;

    @RequestMapping(value = "/dot", method = RequestMethod.GET, produces = MediaType.TEXT_PLAIN_VALUE)
    public HttpEntity<byte[]>
    rdfUrl2Dot(@RequestParam(value="url") String url) throws IOException, TransformerException {
        String dot = rdf2Dot.RDFtoDot(url, FileUtils.guessLang(url));
        return getHttpEntity(dot);
    }

    @RequestMapping(value = "/dot", method = RequestMethod.POST,
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.TEXT_PLAIN_VALUE)
    public HttpEntity<byte[]>
    rdfForm2Dot(@RequestParam(value="rdf") String rdf,
                @RequestParam(value="format") String format) throws IOException, TransformerException {
        String dot = rdf2Dot.RDFtoDot(rdf, format);
        return getHttpEntity(dot);
    }

    @RequestMapping(value = "/dot", method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE,
            consumes = {"text/turtle", "application/rdf+xml", "application/n-triples", "application/ld+json"})
    public HttpEntity<byte[]>
    rdf2Dot(@RequestHeader("Content-Type") String type, @RequestBody String rdf) throws IOException, TransformerException {
        String format;
        switch (type) {
            case "application/rdf+xml":
                format = "RDF/XML"; break;
            case "application/n-triples":
                format = "N-TRIPLES"; break;
            default:
                format = "TURTLE";
        }
        String dot = rdf2Dot.RDFtoDot(rdf, format);
        return getHttpEntity(dot);
    }

    private HttpEntity<byte[]> getHttpEntity(String dot) {
        byte[] dotBytes = dot.getBytes(StandardCharsets.UTF_8);
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.valueOf("text/plain;charset=UTF-8"));
        header.setContentLength(dotBytes.length);
        return new HttpEntity<>(dotBytes, header);
    }
}
