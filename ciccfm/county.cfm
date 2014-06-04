<!--- Information on a Selected County --->

<CFPARAM NAME="URL.id" DEFAULT="">

			
            <CFQUERY NAME="getcountydata" DATASOURCE="naco_cic">
                         SELECT  FIPS, LEFT(fips,2) as StateFIPS, county_name, state, Org_Type, Founded, Board_Size, Gov_type, Population_2010, Member_Status, County_Seat, Total_Square_Miles
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

<div id="responseContent class="container-fluid">

<CFOUTPUT query="getcountydata">
<div class="row">
    <div class="col-md-12">
    	<H3>#county_name#, #state#</H3>
	</div>
</div>

<div id="countyResponse-titleRow" class="row">
 
</div>
    
<div id="countyResponse-basicInfoRow" class="row">
    <div id="countyResponse-countyDetails" class="col-md-6">
        <h4>County Details</h4>
        <table class="table table-condensed">
        	<tr><td>Website:</td><td>  </td></tr>
        	<tr><td>County Seat:</td><td>#County_Seat#</td></tr>
        	<tr><td>Year Organized:</td><td>#Founded#</td></tr>
        	<tr><td>Square Miles:</td><td>#Total_Square_Miles#</td></tr>
        	<tr><td>Persons/Square Mile:</td><td>  </td></tr>
        	<tr><td>Size of Board:</td><td>#Board_Size#</td></tr>
        </table>
    </div>
    
    <div class="col-md-6">
    	<div id="countyResponse-nacoMember">
    		<p><CFIF #Member_Status# EQ "Active">NACo Member County</CFIF></p>
    	</div>
        <div id="countyResponse-populations">
        	<h4>County Populations</h4>
	        <table class="table table-condensed table-striped">
	        	<tr>
	        		<td>2000</td>
	        		<td>2004</td>
	        		<td>2008</td>
	        		<td>2010</td>
	        	</tr>
	        	<tr>
	        		<td>999,999</td>
	        		<td>999,999</td>
	        		<td>999,999</td>
	        		<td>#NumberFormat(Population_2010, "999,999,999,999")#</td>
	        	</tr>
	        </table>
		</div>
		<div id="countyResponse-quickLinks">
	        <h4>Quick Links</h4>
	        <A HREF="http://quickfacts.census.gov/qfd/states/#StateFIPS#/#fips#.html" target="_blank" title="U.S. Census Bureau: State and County QuickFacts">Census Quick Facts</A><BR>
	        <A HREF="http://www.fedstats.gov/qf/states/#StateFIPS#/#fips#.html" title="Fedstats provides access to the full range of official statistical information produced by the Federal Government">Fed Stats</A><BR>
	        <A HREF="http://maps.google.com/maps?q=#county_Name#,#State#" target="_blank" title="View Google Map of County">Google Map View</A>
	    </div>
    </div>  
</div>

</CFOUTPUT>

<CFIF getcountydata.Org_Type EQ "County" OR  getcountydata.Org_Type EQ "Independent City"> 
<div id="countyResponse-electedOfficials" class="row">	
	<strong>Elected Officials</strong></Td><TD width="31%"></strong>
		<Table class="table table-condensed table-striped">
			<CFOUTPUT QUERY="getEXEC">
				<TR>
					<TD><strong>#First_name# #Last_Name# #Suffix#</strong></TD>
		        	<TD>#title#</TD>
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
</div>


<CFOUTPUT query="getcountydata">#county_name# Has No Form Of County Government</cfoutput> 
						
</CFIF>

			
			


</body>




</html>