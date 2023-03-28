package net.rhizomik.redefer.rdf2svg;

import net.rhizomik.redefer.utils.UrlUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;

/**
 * Created by http://rhizomik.net/~roberto/
 */
@Controller
public class RDF2DotController {

    @Autowired RDF2DotService rdf2DotService;

    @RequestMapping(value = "/transform", method = RequestMethod.GET)
    public HttpEntity
    rdfUrl2Svg(@RequestParam(value="url") String url) {
        String dot = "";
        try {
            dot = rdf2DotService.RDFtoDot(url, UrlUtils.guessLang(url));
        } catch (Exception e) {
            return getErrorEntity(e);
        }
        return getHttpEntity(dot);
    }

    @RequestMapping(value = "/transform", method = RequestMethod.POST,
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = "text/plain")
    public HttpEntity
    rdfForm2Svg(@RequestParam(value="rdf") String rdf,
                @RequestParam(value="format") String format) {
        String dot = "";
        try {
            dot = rdf2DotService.RDFtoDot(rdf, format);
        } catch (Exception e) {
            return getErrorEntity(e);
        }
        return getHttpEntity(dot);
    }

    @RequestMapping(value = "/transform", method = RequestMethod.POST,
            consumes = {"text/turtle", "application/rdf+xml", "application/n-triples", "application/ld+json"})
    public HttpEntity
    rdf2Rdf(@RequestHeader("Content-Type") String type, @RequestBody String rdf) {
        String format;
        switch (type) {
            case "application/rdf+xml":
                format = "RDF/XML"; break;
            case "application/n-triples":
                format = "N-TRIPLES"; break;
            case "application/ld+json":
                format = "JSON-LD"; break;
            default:
                format = "TURTLE";
        }
        String dot = "";
        try {
            dot = rdf2DotService.RDFtoDot(rdf, format);
        } catch (Exception e) {
            return getErrorEntity(e);
        }
        return getHttpEntity(dot);
    }

    private HttpEntity<byte[]> getHttpEntity(String xmlSvg) {
        byte[] textDotBody = xmlSvg.getBytes(StandardCharsets.UTF_8);
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.valueOf("text/plain;charset=UTF-8"));
        header.setContentLength(textDotBody.length);
        return new HttpEntity<>(textDotBody, header);
    }

    private HttpEntity<String> getErrorEntity(Exception e) {
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.TEXT_PLAIN);
        header.setContentLength(e.getMessage().length());
        return new HttpEntity<>(e.getMessage(), header);
    }
}
