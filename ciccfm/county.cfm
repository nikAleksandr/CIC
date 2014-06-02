<!--- Information on a Selected County --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Find a County</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../naco_default.css" rel="stylesheet" type="text/css">
</head>



<CFPARAM NAME="URL.id" DEFAULT="">

<CFIF #URL.id# is "">
		<cflocation url="http://www.naco.org">
<CFELSE>
			
<CFQUERY NAME="getcountydata" DATASOURCE="naco_data">
			 SELECT 	 FIPS, company, OrgType, 
			 AddrLine1, AddrLine2,  State, City,  Zip, Phone, fax,
			 Home_Page,  MSA, Population2010, Population2005, MemberType, MemberStatus,
			 Population2000, Population1990, Population1980, founded,  countyseat,
			 SquareMiles, GovernmentType,  Census_State_ID, Census_County_ID, boardsize,
			 CityCountyConsolidationDate, ConsolidationCity, CountyName
			FROM client_naco_AMS_MAST
			WHERE FIPS=  '#URL.id#'
</CFQUERY> 
			
<!--- <CFIF getcountydata.OrgType EQ 'County' OR getcountydata.OrgTypeID EQ 'Independent City'>  --->
					<CFQUERY NAME="getEXEC" DATASOURCE="naco_data">
					SELECT 
						PersonID, First_Name, Last_Name, Suffix, Title, fnctn_code,
						 EMAIL,  CompanyID, elect_appntd, cnty_dist, state, invalidemail
					FROM client_naco_AMS_PEOPLE
					WHERE CountyFIPS = #URL.id#
					  and elect_appntd='Elected' and fnctn_code = '151'
					ORDER BY fnctn_code,  Last_Name
					</CFQUERY> 

					<CFQUERY NAME="getofficials" DATASOURCE="naco_data">
					SELECT 
						PersonID, First_Name, Last_Name, Suffix, Title, fnctn_code,
						 EMAIL, CompanyID, state,  elect_appntd, cnty_dist, invalidemail
					FROM client_naco_AMS_PEOPLE
					WHERE CountyFIPS = <cfqueryparam cfsqltype="cf_sql_varchar"  Value="#URL.id#">
					  and elect_appntd='Elected' and fnctn_code <> '151'
					  and  ((fnctn_code <> '253')  OR (fnctn_code = '253' and State='SC'))
					ORDER BY fnctn_code,  Last_Name
					</CFQUERY> 
			
<!--- </CFIF> --->
			

<body class="body" onLoad="window.focus();">

<!--- <P align="right">
<a href="#" onClick="window.print();return false;" title="Print County Page"><img src="images/icon_print.gif"></a> 
</P>

<A ID="top" name="top"></a> --->






<CFOUTPUT>
			
			<TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="0">
			<TR valign="top">
			<TD VALIGN="TOP" WIDTH="55%">	
				<H3>#getcountydata.company#, #getcountydata.State#</H3>
			<P></P>
			<CFIF #getcountydata.OrgType# eq "County Without Government Structure" or #getcountydata.OrgType# EQ "Geographical Census Area"> &nbsp; <BR>
			<CFELSE>
				#getcountydata.AddrLine1#<BR>
			<CFIF #getcountydata.AddrLine2# EQ ""><CFELSE>#getcountydata.AddrLine2#<BR></CFIF>
				#getcountydata.City#, #getcountydata.State# #getcountydata.Zip#<BR>
				Phone: #getcountydata.Phone#<BR> <!---  <CFIF #getcountydata.fax# EQ""><CFELSE>Fax: #getcountydata.fax#<BR></CFIF> --->
			<CFIF #RTRIM(getcountydata.Home_Page)# is not "">
				Website: <A HREF="#RTRIM(getcountydata.Home_Page)#" target="_blank">#getcountydata.Home_Page#</A>
			</CFIF><P>
		</CFIF>
			</TD>
			
			<TD VALIGN="TOP" WIDTH="40%">	
				<CFIF getcountydata.MemberType EQ "County Membership" AND getcountydata.MemberStatus EQ "Active">
				<strong>NACo Member County</strong>
				<CFELSE>
				<strong>NACo NonMember</strong>
				</CFIF>
   				<P>
						<TABLE  align="left" width="90%" border="1" bordercolorlight="black"  cellpadding="0" cellspacing="0" >
						<TR BGCOLOR="##A5BBD2" align="center">
						<Td colspan="4" align="center" ><b>County Populations</b></td></tr>
						<TR BGCOLOR="##A5BBD2" align="center">
						<Td>&nbsp; 1980 &nbsp;</td>
						<Td>&nbsp; 1990 &nbsp;</td>
						<Td>&nbsp; 2000 &nbsp;</td>
						<Td>&nbsp; 2010 &nbsp;</td>
						</tr>
						<TR align="center" valign="middle">
						<TD><CFIF #getcountydata.Population1980# IS '' > &nbsp; n/a &nbsp; <CFELSE> &nbsp;#NumberFormat(getcountydata.Population1980)#</CFIF> </td>
						<TD><CFIF #getcountydata.Population1990# IS '' > &nbsp; n/a &nbsp; <CFELSE> &nbsp;#NumberFormat(getcountydata.Population1990)#</CFIF> </td>
						<TD><CFIF #getcountydata.Population2000# IS '' > &nbsp; n/a &nbsp; <CFELSE> &nbsp;#NumberFormat(getcountydata.Population2000)#</cfif></td>
						<TD> &nbsp;#NumberFormat(getcountydata.Population2010)#</td>
						</tr>
						</table>
             
       <!---        <A href="https://www.google.com/news/search?hl=en&lr&q=#getcountydata.company# #getcountydata.state#&btnG=Search" target="_blank">
            <strong>Google News</strong> - #getcountydata.company#</A> --->
                      
			</TD>
            
            <TD align="right"> 
             &nbsp; &nbsp;  &nbsp;   <a href="##" onClick="window.print();return false;" title="Print County Page"> Print </a>
            </TD>
			</TR>
			

			
			<CFIF #getcountydata.CityCountyConsolidationDate# IS NOT ''>
			<TR><TD colspan="3"><strong>City-County Consolidation:</strong> 
			#getcountydata.countyname# consolidated with the  #getcountydata.ConsolidationCity# in #getcountydata.CityCountyConsolidationDate#</font>
			</TD></TR></cfif>
			
			
			<TR>
            <TD>
			<b>County Seat:</b> #getcountydata.CountySeat#<BR>
            <CFIF #getcountydata.FIPS# EQ 51087>
            <b>County Organized:</b> City 1611, Shire 1634, Manager 1934<BR>
            <CFELSE>
            <b>County Organized:</b> #getcountydata.founded#<BR>
            </CFIF>
			<b>Square Miles:</b> #NumberFormat(getcountydata.SquareMiles, "9,999.99")#<BR>
			<strong>Size of Board:</strong> #getcountydata.boardsize#<BR>
                      
<A HREF="http://maps.google.com/maps?q=#getcountydata.company#,#getcountydata.state#" target="_blank"    >
Google Map View</A>
			</td>
			
			<TD colspan="2">
			<CFIF #getcountydata.State# is 'DC'>
			<LI> <a href="/cffiles_web/counties/pilt_res.cfm?state=#getcountydata.State#" title="PILT Data">PILT Data for #getcountydata.company#</a>
			<LI> <A HREF="http://nationalatlas.gov/printable/congress.html##DC" title="Congressional District" target="new">Congressional District Maps </A>
			</CFIF>
			<!--- Do not print for Independent Cities --->
			<CFIF #getcountydata.GovernmentType# is not "Independent City" and #getcountydata.State# is not 'DC'>
			<LI>
				<a href= "/cffiles_web/counties/citiescounty.cfm?countyid=#getcountydata.FIPS#">
				Places in #getcountydata.company#
				</a>
			</CFIF> 
			
			<CFIF #getcountydata.FIPS# IS 36061>
			<LI> <a href="http://quickfacts.census.gov/qfd/states/#getcountydata.Census_State_ID#/36005.html" target="_blank">
				Census Bureau Quick Facts  - Bronx</A><BR>
			<LI> <a href="http://quickfacts.census.gov/qfd/states/#getcountydata.Census_State_ID#/36047.html" target="_blank">
				Census Bureau Quick Facts  - Kings</A><BR>
			<LI> <a href="http://quickfacts.census.gov/qfd/states/#getcountydata.Census_State_ID#/36061.html" target="_blank">
				Census Bureau Quick Facts  - New York</A>
			<LI> <a href="http://quickfacts.census.gov/qfd/states/#getcountydata.Census_State_ID#/36081.html" target="_blank">
				Census Bureau Quick Facts  - Queens</A><BR>
			<LI> <a href="http://quickfacts.census.gov/qfd/states/#getcountydata.Census_State_ID#/36085.html" target="_blank">
				Census Bureau Quick Facts  - Richmond</A><BR>
			<LI><a href="http://www.fedstats.gov/qf/states/#getcountydata.Census_State_ID#/36005.html" target="_blank">
				FEDSTATS - Bronx </A>
			<LI><a href="http://www.fedstats.gov/qf/states/#getcountydata.Census_State_ID#/36047.html" target="_blank">
				FEDSTATS - Kings </A>
			<LI><a href="http://www.fedstats.gov/qf/states/#getcountydata.Census_State_ID#/36061.html" target="_blank">
				FEDSTATS - New York </A>
			<LI><a href="http://www.fedstats.gov/qf/states/#getcountydata.Census_State_ID#/36081.html" target="_blank">
				FEDSTATS - Queens </A>
			<LI><a href="http://www.fedstats.gov/qf/states/#getcountydata.Census_State_ID#/36085.html" target="_blank">
				FEDSTATS - Richmond </A>
			<CFELSE>
			<LI> <a href="http://quickfacts.census.gov/qfd/states/#getcountydata.Census_State_ID#/#getcountydata.Census_State_ID##getcountydata.Census_County_ID#.html" target="_blank"  >Census Bureau Quick Facts </A>
            <LI><A HREF="http://quickfacts.census.gov/qfd/states/#getcountydata.Census_State_ID#/#getcountydata.Census_State_ID##getcountydata.Census_County_ID#lk.html" target="_top">Census Bureau Data Sets</A>
<LI><a href="http://www.fedstats.gov/qf/states/#getcountydata.Census_State_ID#/#getcountydata.Census_State_ID##getcountydata.Census_County_ID#.html" target="_blank" >FEDSTATS </A>
			</cfif>

				 
			
			</td>
			</tr>
			
			</TABLE>
			
</CFOUTPUT> 
			
<P>
<!--- Print officials for Counties and Independent Cities Only --->
<CFIF getcountydata.OrgType EQ "County" OR  getcountydata.OrgType EQ "Independent City"> 
						
<CFOUTPUT>
<Table BORDER="1"  CELLSPACING="0" CELLPADDING="2" width="95%">
						<TR BGCOLOR="##A5BBD2" align="center" >
						<Td colspan="2" ><font color="black"><b>Elected County Officials</b></FONT></TH>
						</TR>
						<TR>
						<TD BGCOLOR="##A5BBD2" width="35%">
						<FONT  color="black"><B>Name</B></font></TD>
						<TD BGCOLOR="##A5BBD2" width="65%"><FONT  color="black"><B>Position</B></font></TD>
						</TR>
</CFOUTPUT>
						
						
						
<CFOUTPUT QUERY="getEXEC">
						<TR>
						<TD>
						<!---<CFIF #RTRIM(EMAIL)# is not "" AND #state# NEQ 'TN' AND invalidemail NEQ "1" and #email# DOES NOT CONTAIN "aol.com" >
						  <a href="mailto:#EMAIL#" ><strong>#First_name# #Last_Name# #Suffix#</strong></A> 
						 <CFELSE> --->
						  <strong>#First_name# #Last_Name# #Suffix#</strong>
						
						 </TD>
						 <CFIF cnty_dist GT 0 >
						 <TD><strong>#title#, District  #cnty_Dist#</strong></TD>
						 <CFELSE>
						 <TD><strong>#title#</strong></TD>
						 </CFIF>
						 </TR>
</CFOUTPUT>
						
						
						
<CFOUTPUT QUERY="getofficials">
						<TR>
						<TD>
                          <CFIF #RTRIM(EMAIL)# is not "" AND #state# NEQ 'TN' AND  invalidemail NEQ "1" and #email# DOES NOT CONTAIN "aol.com">
                                                   <a href="mailto:#EMAIL#">#First_name# #Last_Name# #Suffix#</A> #invalidemail#
						 <CFELSE>
						  #First_name# #Last_Name# #Suffix#
						 </CFIF>
						 </TD>
						<CFIF cnty_dist GT 0 and fnctn_code EQ "103" >
								<CFIF state EQ 'TX'>
									<TD>#title#, Precinct #cnty_Dist#</TD>
								<CFELSE>
									<TD>#title#, District #cnty_Dist#</TD>
								</CFIF>		
						   <CFELSE>
						 		  <TD>#title#</TD>
						 </CFIF>
						 </TR>
</CFOUTPUT>
						</Table>
			<CFELSE>
			<CFOUTPUT query="getcountydata"><CENTER>
			<H3> #company# Has No Form Of County Government</h3></CENTER>
			</cfoutput> 
						
			</CFIF>
			<P>
			
			
			<P>
<CENTER>
<A href=#top>top</a>
</CENTER>

</body></CFIF>




</html>