# Introduction

The RDF to SVG service **RDF2SVG** generates a **SVG** graphical representation of the input **RDF** 
following the workflow:

    RDF -rules-> Graph Visualization RDF Model -xslt-> .DOT File -Graphviz-> SVG

The input **RDF** goes through a set of **Jena rules** that select the parts of the **RDF** structure 
to show and models them also using **RDF**. Currently there is **1** set of rules that:
 
* Represents the whole **graph** structure generated by RDF **triples**.
  
Future work is to make available additional rules that:

* Represent just the **hierarchical** structure of the **classes** defined in the input RDF.
* Represent the hierarchy of **parts** in the input RDF.
* Represent the **OWL constructs** in the input RDF defining an **ontology**.

As a result of the reasoning based on the selected set of rules, an output **RDF** modelling the graph structure 
to visualize is generated. This RDF is then processed by an **XSL** transformation that models the same structure 
using the **Graphviz** .DOT format. 

The .DOT file is then sent to **Graphviz**, which layouts the graph visualization and **renders** it as an **SVG**, 
the final output of the **RDF to SVG web service**.

# Deployment


To deploy the ReDeFer RDF2SVG Docker image and make the RDF to SVG service available from port `8080`:

````shell
docker run -p 8080:8080 rhizomik/redefer-rdf2svg
````

Alternatively, you can also use docker-compose and the following `docker-compose.yml`:

```shell
version: '3'
services:
  redefer-rdf2svg:
    image: rhizomik/redefer-rdf2svg
    container_name: redefer-rdf2svg
    ports:
      - "8080:8080"
    environment:
      - NET_RHIZOMIK_REDEFER_RDF2SVG_DOTPATH=/usr/bin/dot
      - JAVA_OPTS=-Xmx512m -Xms128m
```
