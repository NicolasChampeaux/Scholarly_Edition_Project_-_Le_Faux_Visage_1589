<?xml version="1.0" encoding="UTF-8"?>

<!-- Source XSL : Simon Gabay ; adaptation : Sonia Solfrini -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.loc.gov/standards/alto/ns-v4#" version="2.0"
    exclude-result-prefixes="xs">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"
        xpath-default-namespace="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Changer les variables suivantes si nécessaire -->
    
    <xsl:variable name="document">faux_visage</xsl:variable>
    <xsl:variable name="fileName">faux_visage</xsl:variable>
    
    <!-- Changer le "path" si nécessaire : '/Users/sonia/Desktop/SETAF_ALTO2TEI/pipeline/data_alto/' -->
    
    <xsl:variable name="xmlDocuments" select="collection(concat('../altos/', $fileName, '/?select=?*.xml;recurse=yes'))"/>
    
    <xsl:template match="/" >
        <xsl:processing-instruction name="xml-model">
            <xsl:text>href="https://raw.githubusercontent.com/SETAFDH/TEI-SETAF/main/schema/odd-setaf.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
        </xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">
            <xsl:text>href="https://raw.githubusercontent.com/SETAFDH/TEI-SETAF/main/schema/odd-setaf.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
        </xsl:processing-instruction>
        
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$document}">
        
<!-- teiHeader -->

            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Title</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
<!-- sourceDoc -->

            <sourceDoc xml:id="transcription">
                <xsl:for-each select="$xmlDocuments">
                    <xsl:for-each select="//alto">
                        <!-- Page -->
                        <xsl:variable name="page" select="substring-before(self::alto/Description/sourceImageInformation/fileName, '.')"/>
                        <xsl:element name="surface">
                            <!-- ID -->
                            <xsl:attribute name="xml:id">
                                <xsl:text>f</xsl:text>
                                <xsl:value-of select="$page"/>
                            </xsl:attribute>
                            <xsl:attribute name="ulx">
                                <xsl:value-of select="//Page/PrintSpace/@HPOS"/>
                            </xsl:attribute>
                            <xsl:attribute name="uly">
                                <xsl:value-of select="//Page/PrintSpace/@VPOS"/>
                            </xsl:attribute>
                            <xsl:attribute name="lrx">
                                <xsl:value-of select="number(//Page/PrintSpace/@HPOS) + number(//Page/PrintSpace/@WIDTH)"/>
                            </xsl:attribute>
                            <xsl:attribute name="lry">
                                <xsl:value-of select="number(//Page/PrintSpace/@VPOS) + number(//Page/PrintSpace/@HEIGHT)"/>
                            </xsl:attribute>
                            <xsl:element name="graphic">
                                <xsl:attribute name="url">
                                    <xsl:value-of select="self::alto/Description/sourceImageInformation/fileIdentifier"/>
                                </xsl:attribute>
                            </xsl:element>
                            <!-- Régions -->
                            <xsl:for-each select="//TextBlock">
                                <xsl:element name="zone">
                                    <xsl:attribute name="xml:id">
                                        <xsl:text>f</xsl:text><xsl:value-of select="$page"/><xsl:text>_</xsl:text><xsl:value-of select="@ID"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="type">
                                        <!-- Attrapage de la valeur codée -->
                                        <xsl:variable name="type_zone">
                                            <xsl:value-of select="@TAGREFS"/>
                                        </xsl:variable>
                                        <!-- Recherche de la véritable valeur exprimée -->
                                        <xsl:variable name="type_zone_valeur">
                                            <xsl:value-of
                                                select="//OtherTag[@ID = $type_zone]/@LABEL"/>
                                        </xsl:variable>
                                        <xsl:value-of select="$type_zone_valeur"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="n">
                                        <xsl:number level="single" count="." format="1"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ulx">
                                        <xsl:value-of select="@HPOS"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="uly">
                                        <xsl:value-of select="@VPOS"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="lrx">
                                        <xsl:value-of select="number(@HPOS) + number(@WIDTH)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="lry">
                                        <xsl:value-of select="number(@VPOS) + number(@HEIGHT)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="points">
                                        <xsl:variable name="value" select="./Shape/Polygon/@POINTS"/>
                                        <xsl:analyze-string select="$value"
                                            regex="([0-9]+)\s([0-9]+)">
                                            <xsl:matching-substring>
                                                <xsl:for-each select="$value">
                                                    <xsl:value-of select="regex-group(1)"/>
                                                    <xsl:text>,</xsl:text>
                                                    <xsl:value-of select="regex-group(2)"/>
                                                    <xsl:text> </xsl:text>
                                                </xsl:for-each>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:attribute>
                                    <xsl:attribute name="source">
                                        <xsl:value-of
                                            select="substring-before(ancestor-or-self::alto/Description/sourceImageInformation/fileIdentifier, 'full/full')"/>
                                        <xsl:value-of select="@HPOS"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="@VPOS"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="@WIDTH"/>
                                        <xsl:text>,</xsl:text>
                                        <xsl:value-of select="@HEIGHT"/>
                                        <xsl:text>/full/0/default.jpg</xsl:text>
                                    </xsl:attribute>
                                    <!-- Lignes -->
                                    <xsl:for-each select="TextLine">
                                        <xsl:element name="zone">
                                            <xsl:attribute name="xml:id">
                                                <xsl:text>f</xsl:text><xsl:value-of select="$page"/><xsl:text>_</xsl:text><xsl:value-of select="@ID"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="type">
                                                <xsl:text>segmontoLine</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="type">
                                                <!-- Attrapage de la valeur -->
                                                <xsl:variable name="type_zone">
                                                    <xsl:value-of select="@TAGREFS"/>
                                                </xsl:variable>
                                                <!-- Recherche de la véritable valeur -->
                                                <xsl:variable name="type_zone_valeur">
                                                    <xsl:value-of
                                                        select="//OtherTag[@ID = $type_zone]/@LABEL"/>
                                                </xsl:variable>
                                                <xsl:value-of select="$type_zone_valeur"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="n">
                                                <xsl:number level="single" count="." format="1"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="ulx">
                                                <xsl:value-of select="@HPOS"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="uly">
                                                <xsl:value-of select="@VPOS"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="lrx">
                                                <xsl:value-of select="number(@HPOS) + number(@WIDTH)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="lry">
                                                <xsl:value-of select="number(@VPOS) + number(@HEIGHT)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="points">
                                                <xsl:variable name="value"
                                                    select="./Shape/Polygon/@POINTS"/>
                                                <xsl:analyze-string select="$value"
                                                    regex="([0-9]+)\s([0-9]+)">
                                                    <xsl:matching-substring>
                                                        <xsl:for-each select="$value">
                                                            <xsl:value-of select="regex-group(1)"/>
                                                            <xsl:text>,</xsl:text>
                                                            <xsl:value-of select="regex-group(2)"/>
                                                            <xsl:text> </xsl:text>
                                                        </xsl:for-each>
                                                    </xsl:matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:attribute>
                                            <xsl:attribute name="source">
                                                <xsl:value-of
                                                    select="substring-before(ancestor-or-self::alto/Description/sourceImageInformation/fileIdentifier, 'full/full')"/>
                                                <xsl:value-of select="@HPOS"/>
                                                <xsl:text>,</xsl:text>
                                                <xsl:value-of select="@VPOS"/>
                                                <xsl:text>,</xsl:text>
                                                <xsl:value-of select="@WIDTH"/>
                                                <xsl:text>,</xsl:text>
                                                <xsl:value-of select="@HEIGHT"/>
                                                <xsl:text>/full/0/default.jpg</xsl:text>
                                            </xsl:attribute>
                                            <!-- Baseline -->
                                            <xsl:element name="path">
                                                <xsl:variable name="nbaseline">
                                                    <xsl:number level="single" count="." format="1"/>
                                                </xsl:variable>
                                                <xsl:attribute name="n">
                                                    <xsl:value-of select="$nbaseline"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="xml:id">
                                                    <xsl:value-of
                                                        select="concat('f',$page,'_',@ID, '_baseline_', $nbaseline)"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="type">
                                                    <xsl:text>baseline</xsl:text>
                                                </xsl:attribute>
                                                <xsl:attribute name="points">
                                                    <xsl:variable name="value" select="@BASELINE"/>
                                                    <xsl:analyze-string select="$value"
                                                        regex="([0-9]+)\s([0-9]+)">
                                                        <xsl:matching-substring>
                                                            <xsl:for-each select="$value">
                                                                <xsl:value-of select="regex-group(1)"/>
                                                                <xsl:text>,</xsl:text>
                                                                <xsl:value-of select="regex-group(2)"/>
                                                                <xsl:text> </xsl:text>
                                                            </xsl:for-each>
                                                        </xsl:matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:attribute>
                                            </xsl:element>
                                            <!-- Transcription -->
                                            <xsl:element name="line">
                                                <xsl:variable name="nline">
                                                    <xsl:number level="single" count="." format="1"/>
                                                </xsl:variable>
                                                <xsl:attribute name="xml:id">
                                                    <xsl:value-of
                                                        select="concat('f',$page,'_',@ID, '_ligne_', $nline)"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="String/@CONTENT"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </sourceDoc>
            
            <xsl:element name="text">
                <xsl:element name="body">
                    <xsl:element name="p"/>
                </xsl:element>
            </xsl:element>
            
        </TEI>
        
    </xsl:template>
    
</xsl:stylesheet>