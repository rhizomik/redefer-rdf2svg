package net.rhizomik.redefer.rdf2svg;

import org.apache.jena.util.FileUtils;

import javax.xml.transform.TransformerException;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Created by http://rhizomik.net/~roberto/
 */
public class RDF2DotCli {
    private static final Logger log = Logger.getLogger(RDF2DotCli.class.getName());

    public static void main(String[] args) throws IOException, TransformerException, URISyntaxException {
        if (args.length < 1) {
            System.err.println("$> rdf2dot InputRDFFile [OutputRDFFile] ");
            System.exit(-1);
        }

        RDF2DotService rdf2Dot = new RDF2DotService("file:./src/main/resources/rules/showgraph.jrule");

        String dot = "";
        File input = new File(args[0]);
        if (new RDFFileFilter().accept(input, input.getName())) {
            log.log(Level.INFO, "Processing file: " + input);
            dot = rdf2Dot.RDFtoDot(input.toURI().toString(), FileUtils.guessLang(input.getName()));
        }
        else{
            System.err.println("$> Accepted file extensions: .rdf, .nt, .ttl and .owl");
            System.exit(-1);
        }

        if (args.length > 1) {
            PrintWriter out = new PrintWriter(args[1]);
            out.println(dot);
            out.close();
        } else
            System.out.println(dot);
    }

    private static class RDFFileFilter implements FilenameFilter {

        public boolean accept(File file, String fileName) {
            return fileName.endsWith(".rdf") || fileName.endsWith(".ttl") ||
                   fileName.endsWith(".nt")  || fileName.endsWith(".owl");
        }
    }
}
