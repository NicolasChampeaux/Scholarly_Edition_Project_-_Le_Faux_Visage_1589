<?xml version="1.0" encoding="UTF-8"?>

<!-- Source XSL : Simon Gabay ; adaptation : Nicolas Champeaux -->

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
    
    <!-- Template for surface Elements within body: -->
    
    <xsl:template match="surface[ancestor::body]">
        <xsl:element name="pb" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="corresp"><xsl:value-of select="@xml:id"/></xsl:attribute>
        </xsl:element> 
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Template for zone Elements within body/surface : -->
    
    <xsl:template match="//body/surface/zone">
        <xsl:choose>
            <xsl:when test="@type='MainZone-P'">
                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='MainZone-Continued'">
                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='MainZone-Sp'">
                <xsl:element name="sp" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='MainZone-Lg'">
                <xsl:element name="lg" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='MainZone-Head'">
                <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='NumberingZone'">
                <!-- <fw> (forme work) contains a running head (e.g. a header, footer), catchword, or similar material appearing on the current page. -->
                <xsl:element name="fw" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='QuireMarksZone'">
                <!-- <fw> (forme work) contains a running head (e.g. a header, footer), catchword, or similar material appearing on the current page. -->
                <xsl:element name="fw" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>   
            </xsl:when>
            <xsl:when test="@type='RunningTitleZone'">
                <!-- <fw> (forme work) contains a running head (e.g. a header, footer), catchword, or similar material appearing on the current page. -->
                <xsl:element name="fw" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='TitlePageZone'">
                <!-- <ab> (anonymous block) contains any component-level unit of text, acting as a container for phrase or inter level elements analogous to, but without the same constraints as, a paragraph. -->
                <xsl:element name="ab" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='DropCapitalZone'">
                <!-- <ab> (anonymous block) contains any component-level unit of text, acting as a container for phrase or inter level elements analogous to, but without the same constraints as, a paragraph. -->
                <xsl:element name="ab" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='MarginTextZone-Notes'">
                <!-- <note> (note) contains a note or annotation. -->
                <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <xsl:when test="@type='MarginTextZone-ManuscriptAddendum'">
                <!-- <note> (note) contains a note or annotation. -->
                <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>      
            </xsl:when>
            <!-- GraphicZone with some text? -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="//body/surface/zone/zone">
        <xsl:choose>
            <xsl:when test="@type='DefaultLine'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='HeadingLine'">
                <xsl:element name="hi" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type='DropCapitalLine'">
                <xsl:element name="hi" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="line[ancestor::body]">
        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="corresp"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:attribute>
        </xsl:element>
        <xsl:element name="choice" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="orig" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:element name="reg" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">intermediary</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="path[ancestor::body]"/>
    <xsl:template match="graphic[ancestor::body]"/>
    
</xsl:stylesheet>