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
public class RDF2SVGController {

    @Autowired RDF2SVGService rdf2SvgService;

    @RequestMapping(value = "/render", method = RequestMethod.GET)
    public HttpEntity
    rdfUrl2Svg(@RequestParam(value="url") String url) {
        String svg = "";
        try {
            svg = rdf2SvgService.RDFtoSVG(url, UrlUtils.guessLang(url));
        } catch (Exception e) {
            return getErrorEntity(e);
        }
        return getHttpEntity(svg);
    }

    @RequestMapping(value = "/render", method = RequestMethod.POST,
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = "image/svg+xml")
    public HttpEntity
    rdfForm2Svg(@RequestParam(value="rdf") String rdf,
                @RequestParam(value="format") String format) {
        String svg = "";
        try {
            svg = rdf2SvgService.RDFtoSVG(rdf, format);
        } catch (Exception e) {
            return getErrorEntity(e);
        }
        return getHttpEntity(svg);
    }

    @RequestMapping(value = "/render", method = RequestMethod.POST,
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
        String svg = "";
        try {
            svg = rdf2SvgService.RDFtoSVG(rdf, format);
        } catch (Exception e) {
            return getErrorEntity(e);
        }
        return getHttpEntity(svg);
    }

    private HttpEntity<byte[]> getHttpEntity(String xmlSvg) {
        byte[] xmlSvgBody = xmlSvg.getBytes(StandardCharsets.UTF_8);
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.valueOf("image/svg+xml;charset=UTF-8"));
        header.setContentLength(xmlSvgBody.length);
        return new HttpEntity<>(xmlSvgBody, header);
    }

    private HttpEntity<String> getErrorEntity(Exception e) {
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.TEXT_PLAIN);
        header.setContentLength(e.getMessage().length());
        return new HttpEntity<>(e.getMessage(), header);
    }
}
