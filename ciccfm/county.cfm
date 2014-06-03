<!--- Information on a Selected County --->

<CFPARAM NAME="URL.id" DEFAULT="">

			
            <CFQUERY NAME="getcountydata" DATASOURCE="naco_cic">
                         SELECT  FIPS, county_name, state, Org_Type
                         FROM County_data
                        WHERE FIPS=  '#URL.id#'
            </CFQUERY> 
                        

            <CFQUERY NAME="getEXEC" DATASOURCE="naco_cic">
            SELECT 
                PersonID, First_Name, Last_Name, Suffix, Title, fnctn_code,  elect_appntd, cnty_dist, state, fips
            FROM cic_county_officials
            WHERE FIPS = '#URL.id#'
              and elect_appntd='Elected' and fnctn_code = '151'
            ORDER BY fnctn_code,  Last_Name
            </CFQUERY> 

            <CFQUERY NAME="getofficials" DATASOURCE="naco_cic">
            SELECT 
                PersonID, First_Name, Last_Name, Suffix, Title, fnctn_code, state,  elect_appntd, cnty_dist,  fips
            FROM cic_county_officials
            WHERE FIPS = '#URL.id#'
              and elect_appntd='Elected' and fnctn_code <> '151'
              and  ((fnctn_code <> '253')  OR (fnctn_code = '253' and State='SC'))
            ORDER BY fnctn_code,  Last_Name
            </CFQUERY> 
			
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Find a County</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../naco_default.css" rel="stylesheet" type="text/css">
</head>

<body class="body">




			
<P>

<CFIF getcountydata.Org_Type EQ "County" OR  getcountydata.Org_Type EQ "Independent City"> 
						<Table align="center" BORDER="0"  CELLSPACING="0" CELLPADDING="2" width="50%">
						<TR align="left" >
						<Td colspan="2" ><strong><CFOUTPUT query="getcountydata">#county_name#, #state#</CFOUTPUT> &nbsp; &nbsp; Elected Officials</strong><P>
                        </Tr>
						</TR>
						<!--- <TR><TD width="35%">Name</TD>
						<TD width="65%">Position</TD>
						</TR> --->
						<CFOUTPUT QUERY="getEXEC">
						<TR>
						<TD><strong>#First_name# #Last_Name# #Suffix#</strong></TD>
						 <CFIF cnty_dist GT 0 >
                         <TD><strong>#title#, District  #cnty_Dist#</strong></TD>
                         <CFELSE>
						 <TD><strong>#title#</strong></TD>
						 </CFIF>
						 </TR>
</CFOUTPUT>
						
						
						
<CFOUTPUT QUERY="getofficials">
						<TR>
						<TD>#First_name# #Last_Name# #Suffix# </TD>
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



<CFOUTPUT query="getcountydata">#county_name# Has No Form Of County Government</cfoutput> 
						
</CFIF>

			
			


</body>




</html>