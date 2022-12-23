# DITA Perspectives

This project provides an insight into a set of DITA RelaxNG based schemas.
Using it you can obtain an overview of the DITA XML architecture of elements and inheritances:
https://blog.oxygenxml.com/topics/dp/dita_perspectives.html

The first step is to extract information from the RelaxNG schemas into an XML format, this is done by the `categories.xsl` and `categories2.xsl` stylesheets, the first one handles the DITA 1.3 schema structure and the other the DITA 2.0 schema structure, because there were some changes in how the schemas are organized.

Then, from this generated XML data we extract various information about DITA elements, modules, etc. This information is generated in an XML structure that is used then to generate a visual representation using [graphviz](https://graphviz.org/). This XML representation has a project level framework called `graphModel` defined in `frameworks/graphModel`. The `graphModel` files can be processed to generated `DOT` files that are used by *graphwiz* to generate actual graphics in different formats, we use `SVG`. 

**Note:** You need to install *graphwiz*, see [https://graphviz.org/download/](https://graphviz.org/download/) and make sure the `build.xml` points to the location of the `dot` executable from your local installation, for example in my case that is`/usr/local/bin/dot` and this is the default set in the `build.xml` script. 

Along with the `SVG` diagrams we generate also some DITA content, when there is a variable number of topics, like generating a topic for each domain for example. There is also some static DITA content found in the `report` folder.

In the end the static content from the `report-template` folder is combined with the dynamically generated DITA content and with the generated diagrams to obtain a DITA project that includes information about a set of DITA RelaxNG schemas, DITA 1.3 or DITA 2.0 in the case of the sample DITA schemas included in this project. 

This DITA content may be used then further as you wish, for example to publish it to PDF or HTML/WebHelp format, or you may include it into a larger DITA documentation project.

The transformations are orchestrated using an `ant` build file, `build.xml` found in the `scripts` folder. There are two Oxygen XML Editor transformation scenarios configured at project level called `Build allReports` and `Build cleanReports` - the first one will generate the reports for DITA 1.3 in the `generated-reports/DITA13` folder and for DITA 2.0 in the `generated-reports/DITA20` folder inside the project directory.

There is also a `run.sh` shell script that is used to trigger the `ant` build with the `allReports` target to generate the documentation for the DITA 1.3 schemas and for DITA 2.0 schemas and this adds some libraries that are needed to apply the XSLT 3.0 stylesheets that we use and you may need to adjust the pointers to the libraries to match your configuration.  

The `softGeneralizationCSSonly` folder contains a DITA framework specialization which presents for an opened DITA topic buttons which can be used to see for each element what base element it extends. 









