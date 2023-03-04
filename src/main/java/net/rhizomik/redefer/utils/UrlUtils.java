package net.rhizomik.redefer.utils;

import org.apache.jena.util.FileUtils;

public class UrlUtils {
    public static String guessLang(String name) {
        String suffix = FileUtils.getFilenameExt(name);
        switch (suffix) {
            case "n3":
                return "N3";
            case "nt":
                return "N-TRIPLES";
            case "ttl":
                return "TURTLE";
            case "json":
            case "jsonld":
                return "JSON-LD";
            default:
                return "RDF/XML";
        }
    }
}
