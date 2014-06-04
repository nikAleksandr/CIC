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

<div id="responseContent" class="container-fluid">

<CFOUTPUT query="getcountydata">
<div id="countyResponse-title" class="row">
    <div class="col-md-12">
    	<H3>#county_name#, #state#</H3>
	</div>
</div>
<CFIF #Member_Status# EQ "Active">   
	<div id="countyResponse-memberRow" class="row">
		<div id="countyResponse-nacoMember" class="col-md-12">
			<h4>NACo Member County</h4>
		</div>
	</div>   
</CFIF>
<div id="countyResponse-basicInfoRow" class="row">
    <div id="countyResponse-countyDetails" class="col-md-6">
        <h4>County Details</h4>
        <table class="table table-condensed">
        	<tr><th>Website:</th><td><a href="http://nacocic.naco.org/">NACoCIC.NACo.org</a></td></tr>
        	<tr><th>County Seat:</th><td>#County_Seat#</td></tr>
        	<tr><th>Year Organized:</th><td>#Founded#</td></tr>
        	<tr><th>Square Miles:</th><td>#Total_Square_Miles#</td></tr>
        	<tr><th>Persons/Square Mile:</th><td> 999,999 </td></tr>
        	<tr><th>Size of Board:</th><td>#Board_Size#</td></tr>
        </table>
    </div>
    
    <div class="col-md-6">
        <div id="countyResponse-populations">
        	<h4>County Populations</h4>
	        <table class="table table-condensed table-striped">
	        	<tr>
	        		<th>2000</th>
	        		<th>2004</th>
	        		<th>2008</th>
	        		<th>2010</th>
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
	        <ul>
	        	<li><A HREF="http://quickfacts.census.gov/qfd/states/#StateFIPS#/#fips#.html" target="_blank" title="U.S. Census Bureau: State and County QuickFacts">Census Quick Facts</A></li>
	        	<li><A HREF="http://www.fedstats.gov/qf/states/#StateFIPS#/#fips#.html" title="Fedstats provides access to the full range of official statistical information produced by the Federal Government">Fed Stats</A></li>
	        	<li><A HREF="http://maps.google.com/maps?q=#county_Name#,#State#" target="_blank" title="View Google Map of County">Google Map View</A></li>
	        </ul>
	    </div>
    </div>  
</div>

</CFOUTPUT>

<CFIF getcountydata.Org_Type EQ "County" OR  getcountydata.Org_Type EQ "Independent City"> 
<div id="countyResponse-electedOfficials" class="row">	
	<h4>Elected Officials</strong></h4>
		<Table class="table table-condensed table-striped">
			<CFOUTPUT QUERY="getEXEC">
				<TR>
					<TD><strong>#First_name# #Last_Name# #Suffix#</strong></TD>
		        	<TD>#title#</TD>
		        </TR>
			</CFOUTPUT>
							
							
							
	<CFOUTPUT QUERY="getofficials">
			<TR>
				<TD style="width:50%; text-align:right;">#First_name# #Last_Name# #Suffix# </TD>
				<CFIF cnty_dist GT 0 and fnctn_code EQ "103" >
						<CFIF state EQ 'TX'>
							<TD style="text-align:left;">#title#, Precinct #cnty_Dist#</TD>
						<CFELSE>
							<TD style="text-align:left;">#title#, District #cnty_Dist#</TD>
						</CFIF>		
				   <CFELSE>
				 		  <TD style="width: 50%; text-align:left;">#title#</TD>
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