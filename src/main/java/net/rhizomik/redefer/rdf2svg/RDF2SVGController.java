package net.rhizomik.redefer.rdf2svg;

import org.apache.jena.util.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpRequest;
import org.springframework.http.MediaType;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.TransformerException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * Created by http://rhizomik.net/~roberto/
 */
@Controller
public class RDF2SVGController {

    @Autowired RDF2SVGService rdf2SvgService;

    @RequestMapping(value = "/render", method = RequestMethod.GET, produces = "image/svg+xml")
    public HttpEntity<byte[]>
    rdfUrl2Svg(@RequestParam(value="url") String url) throws IOException, TransformerException {
        String svg = rdf2SvgService.RDFtoSVG(url, FileUtils.guessLang(url));
        return getHttpEntity(svg);
    }

    @RequestMapping(value = "/render", method = RequestMethod.POST,
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = "image/svg+xml")
    public HttpEntity<byte[]>
    rdfForm2Svg(@RequestParam(value="rdf") String rdf,
                @RequestParam(value="format") String format) throws IOException, TransformerException {
        String svg = rdf2SvgService.RDFtoSVG(rdf, format);
        return getHttpEntity(svg);
    }

    @RequestMapping(value = "/render", method = RequestMethod.POST, produces = "image/svg+xml",
            consumes = {"text/turtle", "application/rdf+xml", "application/n-triples"})
    public HttpEntity<byte[]>
    rdf2Rdf(@RequestHeader("Content-Type") String type, @RequestBody String rdf) throws IOException, TransformerException {
        String format;
        switch (type) {
            case "application/rdf+xml":
                format = "RDF/XML"; break;
            case "application/n-triples":
                format = "N-TRIPLES"; break;
            default:
                format = "TURTLE";
        }
        String xmlRdf = rdf2SvgService.RDFtoSVG(rdf, format);
        return getHttpEntity(xmlRdf);
    }

    private HttpEntity<byte[]> getHttpEntity(String xmlSvg) {
        byte[] xmlSvgBody = xmlSvg.getBytes(StandardCharsets.UTF_8);
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.valueOf("image/svg+xml;charset=UTF-8"));
        header.setContentLength(xmlSvgBody.length);
        return new HttpEntity<>(xmlSvgBody, header);
    }
}
