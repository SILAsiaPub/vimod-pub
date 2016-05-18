# VimodPub project started

## The project aims to make available an open XML publishing tool chain.

Added by Ian McQuay 2013-03-15


XML today is one of the standards in the publishing industry. Some publishers start and end in XML, while others end there and some use it in the middle. This project aims to bring together a set of generalized XSLT transformations for processing XML. The input could be various structured input SFM or XML or ???. Many outputs would be XHTML based but not all.

The tool chain is run by a batch file that is modifiable to add new input types, processing features or output types. At a minimum you set an input file and a list of tasks to be done. Each task takes the previous output as its input by default. It also numbers and names the output file so changes can be compared. Many generalized XSLTs require parameters. XSLTs that take parameters are preferred for recyclability. The dream is to have scripts that non-XSLT writers can use, by just adding parameters.

As I work on various Digital publishing projects, I find that one source in XML can be quickly output in different output formats. Once say one format is achieved, the next takes less time to achieve and so on.

DITA is a fix form of digital publishing that requires Schema compliance. VimodPud does not use schema but does demand valid XML.