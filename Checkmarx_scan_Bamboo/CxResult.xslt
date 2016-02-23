<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">

	<xsl:output method="xml" indent="yes" encoding="iso-8859-1"/>

	<xsl:template match="/">
		<html>
			<body>
				<H1>CHECKMARX RESULT SUMMARY</H1>        
        
        Direct Access: <A href="{//Result[1]/@DeepLink}"> <xsl:value-of select = "//Result[1]/@DeepLink" /></A>
        
        <H1></H1>
        <table border="1">
						<tr>
									<th>
										<span>
											<xsl:text>Vulnerability</xsl:text>
										</span>
									</th>
									<th>
										<span>
											<xsl:text>Severity</xsl:text>
										</span>
									</th>
									<th>
										<span>
											<xsl:text>Results</xsl:text>
										</span>
									</th>
								</tr>
								<tr>
									<td/>
									<td/>
									<td/>
								</tr>
						
								<xsl:for-each select="CxXMLResults">
									<xsl:for-each select="Query[@Severity='High']">
										<xsl:sort select="@Severity" data-type="text" order="ascending"/>
										<xsl:sort select="count( Result )" data-type="number" order="descending"/>
										<xsl:sort select="@name" data-type="text" order="ascending"/>
										<tr>
											<td>
												<xsl:for-each select="@name">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td bgcolor="red">
												<xsl:for-each select="@Severity">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td>
												<span>
													<xsl:value-of select="count( Result )"/>
												</span>
											</td>
										</tr>
									</xsl:for-each>
									<xsl:for-each select="Query[@Severity='Medium']">
										<xsl:sort select="@Severity" data-type="text" order="ascending"/>
										<xsl:sort select="count( Result )" data-type="number" order="descending"/>
										<xsl:sort select="@name" data-type="text" order="ascending"/>
										<tr>
											<td>
												<xsl:for-each select="@name">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td bgcolor="orange">
												<xsl:for-each select="@Severity">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td>
												<span>
													<xsl:value-of select="count( Result )"/>
												</span>
											</td>
										</tr>
									</xsl:for-each>
									<xsl:for-each select="Query[@Severity='Low']">
										<xsl:sort select="@severity" data-type="text" order="ascending"/>
										<xsl:sort select="count( Result )" data-type="number" order="descending"/>
										<xsl:sort select="@name" data-type="text" order="ascending"/>
										<tr>
											<td>
												<xsl:for-each select="@name">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td bgcolor="yellow" >
												<xsl:for-each select="@Severity">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td>
												<span>
													<xsl:value-of select="count( Result )"/>
												</span>
											</td>
										</tr>
									</xsl:for-each>
									
									<xsl:for-each select="Query[@Severity='Information']">
										<xsl:sort select="@Severity" data-type="text" order="ascending"/>
										<xsl:sort select="count( Result )" data-type="number" order="descending"/>
										<xsl:sort select="@name" data-type="text" order="ascending"/>
										<tr>
											<td>
												<xsl:for-each select="@name">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td bgcolor="blue" >
												<xsl:for-each select="@Severity">
													<span>
														<xsl:value-of select="string(.)"/>
													</span>
												</xsl:for-each>
											</td>
											<td>
												<span>
													<xsl:value-of select="count( Result )"/>
												</span>
											</td>
										</tr>
									</xsl:for-each>
									
								</xsl:for-each>
							
						</table>
		</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>
