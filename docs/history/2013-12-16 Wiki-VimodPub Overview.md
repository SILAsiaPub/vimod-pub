#VimodPub Overview

## Various Inputs Mutiple Output Digital Publishing

  * a tool chain environment
  * (Ian's prototyping, transformation, testing and publishing environment)

This is a set of (XP, Win7) files that can fairly quickly create various publishing outputs from one or more sources.

This tool set is aimed at publishers doing digital publishing.

The working format is XML with preferred processing via XSLT2 using Saxon9. Consistent Changes tables are included in the basic tool set. Other command line tools can be used via a plugin batch file, in the plugin directory.

Input formats:

* XML
* XHTML
* SFM
* other structured text input
* 
The outputs could be:

* HTML5 or XHTML
* ePub (indirectly)
* DictionryForMids
* PDF via (PrinceXML or WkHtmltoPDF, or FOP)
* text files for Java Apps
* Smart phone App content.

No DTD or schema is needed. The XML will most likely need some structure.

GettingStarted

GettingStarted.txt (3.1 KB) Ian McQuay, 2013-12-16 01:40 pm