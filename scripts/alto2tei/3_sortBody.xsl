<?xml version="1.0" encoding="UTF-8"?>

<!-- Source XSL : Simon Gabay ; adaptation : Sonia Solfrini -->

<!-- XSLT Stylesheet Declaration: The following block defines the document as an XSLT stylesheet, declares the namespaces used within the document, specifies the XSLT version (2.0), and sets the default namespace for XPath expressions to the TEI namespace. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <!-- Output Specification: The following block instructs the processor to output the result as XML, use UTF-8 encoding, and indent the output for readability. -->
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <!-- Whitespace Stripping: The following block removes leading and trailing whitespace from all elements to tidy up the output. -->
    
    <xsl:strip-space elements="*"/>

    <!-- Identity Transform Template: The following template is an identity transform, a common pattern in XSLT used to copy the current node and all its attributes and child nodes as-is, unless a more specific template matches them. -->
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!--Template for body Elements: The following template directly targets body elements in the XML document. It creates a new body element (ensuring it's in the TEI namespace) and within it: Uses an xsl:for-each loop to process each surface element found within the body; Sorts these surface elements numerically based on a substring of their xml:id attribute that follows the character 'f'; Copies the sorted surface elements as they are into the output. -->
    
    <xsl:template match="//body">
        <body xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:for-each select="surface">
                <xsl:sort select="substring-after(@xml:id, 'f')" data-type="number"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </body>
    </xsl:template>
    
</xsl:stylesheet>